package main

import (
	"errors"
	"fmt"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
	"github.com/pelletier/go-toml/v2"
)

type Config struct {
	Port  uint64
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

	e := echo.New()

	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "hello from my blog")
	})

	e.Logger.Fatal(e.Start(fmt.Sprintf(":%d", cfg.Port)))
}
