@echo off
REM ==========================================
REM  run_exps.bat — автоматизация экспериментов
REM  Usage: run_exps.bat [output_csv]
REM  По умолчанию сохраняет в results.csv
REM ==========================================

setlocal ENABLEDELAYEDEXPANSION

REM ===== Параметры =====
if "%~1"=="" (
    set OUT=results.csv
) else (
    set OUT=%~1
)

REM Размеры матриц (strong scaling)
set M=2000
set N=2000
set K=2000

REM Количество повторов
set REPEATS=3

REM Список потоков (можно под свой CPU)
set PS=1 2 4 6 12 20 32

echo M,N,K,P,run,elapsed > %OUT%

REM ===== Запуски =====
for %%P in (%PS%) do (
    for /L %%r in (1,1,%REPEATS%) do (
        echo Running M=%M% N=%N% K=%K% P=%%P run=%%r
        for /f %%t in ('matrix_mul.exe %M% %N% %K% %%P 2^>NUL') do (
            echo %M%,%N%,%K%,%%P,%%r,%%t >> %OUT%
        )
    )
)

echo.
echo ===============================
echo Все эксперименты завершены.
echo Результаты сохранены в %OUT%
echo ===============================
pause