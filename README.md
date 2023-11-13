# Picross Solver
## Demo Video
- Black and White (B&W) Picross
    <img width="100%" src="Image/BnW Picross Demo.gif"/>
- Color Picross
    <img width="100%" src="Image/Color Picross Demo.gif"/>

## Requirement
- MATLAB2023a
## How to execute
To execute the B&W Picross solver, you should change the workspace location to `matlab/BnW_Picross/bnw_picross_solver` and run `main.m`.
```matlab
>> cd matlab/BnW_Picross/bnw_picross_solver

>> main
```

To execute the Color Picross solver, you should change the workspace location to `matlab/Color_Picross/color_picross_solver` and run `main.m`.
```matlab
>> cd matlab/Color_Picross/color_picross_solver

>> main
```

## Custom Picross
If you want to solve a custom puzzle using B&W Picross solver, first create a `<location>/<name>.txt` file in the following format. The keyword `<location>` represents the folder that puzzle data file is located, and `<name>` means the name of the data file.
```
n_row n_col

row_clue 1
...
row_clue n_row

col_clue 1
...
col_clue n_col
```
The parameters `n_row` and `n_col` mean the the number of rows and columns, respectively. The parameter `row_clue i` means the clue of `i`-th row, and `col_clue i` means the clue of `i`-th column. 

Then substitute `<location>/<name>.txt` to the keyword argument `file` of the function `Parameter.get_parameter` in the file `main.m`
```matlab
param = Parameter.get_parameter(file="<location>/<name>.txt")
```

Finally, execute `main.m`
```matlab
>> main
```

If you want to solve a custom puzzle using Color Picross solver, first create a `<location>/<name>.txt` file in the following format. The keyword `<location>` represents the folder that puzzle data file is located, and `<name>` means the name of the data file.
```
n_row n_col n_color

color 1
...
color n_color

row_clue 1
...
row_clue n_row

col_clue 1
...
col_clue n_col

row_color 1
...
row_color n_row

col_color 1
...
col_color n_col
```
The parameter `n_color` represents the number of colors used in the picross. The parameter `color i` means the `i`-th color used in the picross. The parameters `row_color i`, `col_color i` represent the color indices response to `row_clue i`, `col_clue i`, respectively.