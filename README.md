# Picross Solver

## Demo Video
- 흑백 피크로스
    <img width="100%" src="Image/BnW Picross Demo.gif"/>
- 컬러 피크로스
    <img width="100%" src="Image/Color Picross Demo.gif"/>

## Requirement
- MATLAB2023a

## How to execute
만약 흑백 피크로스 솔버를 이용하고 싶으시다면 `BnW_Picross` 폴더 안에 있는 `bnw_picross_solver`폴더로 이동해 주시면 됩니다.

```matlab
cd BnW_Picross/bnw_picross_solver
```

그런 다음 `main.m`을 동작시켜주면 됩니다.
```matlab
main
```

만약 컬러 피크로스 솔버를 이용하고 싶으시다면 `Color_Picross` 폴더 안에 있는 `Test`폴더로 이동하시면 됩니다. 그리고 `main.m`을 동작시켜주면 됩니다.
```matlab
cd Color_Picross/Test

main
```

## Custom Picross
흑백 피크로스를 커스텀으로 하고 싶으시다면 먼저 다음 format에 맞추어 `.txt`파일을 생성해 주시면 됩니다.

```
n_row n_col

row_clue 1
...
row_clue n_row

col_clue 1
...
col_clue n_col
```

그런 다음 `main.m` 내의 `Parameter.get_parameter`의 인수 중 `file=` 옆에 앞서 생성한 파일 이름을 작성해 주시면 됩니다.

참고로 컬러 피크로스의 format은 다음과 같습니다.

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