@echo off
pushd %~dp0
setlocal

set ROOT=%~dp0
set XFPL_SMCPATH=%ROOT%..\MethodCatalog
set RPSMFIL=%ROOT%..\..\Repository\rpsmain.ism
set RPSTFIL=%ROOT%..\..\Repository\rpstext.ism

set STRUCTURES=CUSTOMERS ITEMS ORDERS ORDER_ITEMS VENDORS
set ALIASES=CUSTOMER ITEM ORDER ORDER_ITEM VENDOR

codegen -s %STRUCTURES% -a %ALIASES% -t StructureMethods -i . -o %ROOT%..\source\methods -ut XF_INTERFACE=MyApi XF_ELB=EXE:xfplMethods -e -r -lf

endlocal
popd

pause
