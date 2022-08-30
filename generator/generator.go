package main

import (
	"errors"
	"fmt"
	"html/template"
	"io"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
	"github.com/pelletier/go-toml/v2"
)

type Config struct {
	Port  uint64
	Title string
}

type Template struct {
	templates *template.Template
}

func (t *Template) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	return t.templates.ExecuteTemplate(w, name, data)
}

type PageData struct {
	Title string
}

func main() {
	if _, err := os.Stat("config.toml"); errors.Is(err, os.ErrNotExist) {
		fmt.Println("config.toml doesn't exist.")
		return
	}

	cfgFile, err := os.ReadFile("config.toml")
	if err != nil {
		fmt.Println("Failed to read config.toml: ", err.Error())
		return
	}

	var cfg Config
	err = toml.Unmarshal(cfgFile, &cfg)
	if err != nil {
		fmt.Println("Failed to parse config.toml: ", err.Error())
		return
	}

	t := &Template{
		templates: template.Must(template.ParseGlob("template/*.html")),
	}

	e := echo.New()
	e.Renderer = t

	e.Static("/static", "static")

	e.GET("/", func(c echo.Context) error {
		return c.Render(http.StatusOK, "index.html", PageData{
			Title: cfg.Title,
		})
	})

	e.Logger.Fatal(e.Start(fmt.Sprintf(":%d", cfg.Port)))
}
