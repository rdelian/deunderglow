# Effects
There are 2 types of effects `"step"` and `"breath"`. Both support single and multi colors as well as custom input from user for the first color.

### Syntax

| option   | description                     | required |
|----------|---------------------------------|----------|
| `title`  | Button name in Effects menu     |    YES   |
| `type`   | "step" OR "breath"              |    YES   |
| `input`  | Allow the user to enter a RGB value | OPTIONAL |
| `colors` | a list with colors              |    YES   |

### Example
```lua
{
    title = "Red & White",
    type = "breath",
    colors = {
        {255, 0, 0},
        {255, 255, 255}
    }
}
```
_For more examples see `./config.lua`_
<br><br>

# Toggles
Neons will be enabled and disabled based on the values inside `anim`

### Syntax
| option   | description                                            | required |
|----------|--------------------------------------------------------|----------|
| `title`  | Button name in Toggles menu                            | YES      |
| `echo`   | Play the effect in a loop (reverse play once finished) | OPTIONAL |
| `anim`   | a list with neons state step by step                   | YES      |
---

`anim` => each element of the list contains a list with 4 values which ca be either 1 or 0 <br>
These indicates if the specific neons should be on or off. The order is the following _LEFT, RIGHT, FRONT, BACK_ <br>

So if we wanna have an effect which will turn on the sides and then the front an rear one, it will look like this:

```lua
...
anim = {
    {1, 1, 0, 0},
    {0, 0, 1, 1}
}
...
```

### Example
```lua
-- this will toggle the neons in this order: REAR > SIDES > FRONT
{
    title = "Forward",
    echo = false,
    anim = {
        {0, 0, 0, 1},
        {1, 1, 0, 0},
        {0, 0, 1, 0}
    }
}
```
_For more examples see `./config.lua`_