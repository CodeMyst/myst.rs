# About zigmath

Naive math lib intended for games written in Zig.

Check out the [source](https://github.com/codemyst/zigmath).

Example:

```zig
const x = m4.init().muls(5);

const res = x.inverse();

const x = m4.perspective(1.57, 1.7, 0, 5);

const x = m4.orthographic(0, 1280, 720, 0, 5, 10);
```
