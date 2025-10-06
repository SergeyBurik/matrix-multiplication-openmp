@echo off
setlocal enabledelayedexpansion

REM ===== Настройки =====
set EXE=matrix_mul.exe
set BASE_SIZE=1000
set /a RUNS=3
set OUTPUT=results_weak.csv

echo M,N,K,P,run,elapsed > %OUTPUT%

REM ===== Список потоков =====
for %%P in (1 2 4 6 12 20 32) do (
    REM вычисляем коэффициент увеличения размера с помощью Python
    for /f "usebackq tokens=*" %%S in (`python -c "import sys, math; P=int(sys.argv[1]); BASE=int(sys.argv[2]); print(int(round(BASE * P**(1/3))))" %%P %BASE_SIZE%`) do (
        set SIZE=%%S
        echo Running weak scaling test with P=%%P, size=!SIZE!x!SIZE!x!SIZE!
        for /L %%R in (1,1,%RUNS%) do (
            for /f "usebackq tokens=*" %%T in (`%EXE% !SIZE! !SIZE! !SIZE! %%P`) do (
                echo !SIZE!,!SIZE!,!SIZE!,%%P,%%R,%%T >> %OUTPUT%
            )
        )
    )
)

echo Done! Results saved to %OUTPUT%
pause
