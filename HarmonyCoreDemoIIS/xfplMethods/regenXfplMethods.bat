@echo off
pushd %~dp0
setlocal

set ROOT=%~dp0
set STRUCTURES=CUSTOMERS ITEMS ORDERS ORDER_ITEMS VENDORS
set ALIASES=CUSTOMER ITEM ORDER ORDER_ITEM VENDOR
set TEMPLATES=xf_net_add xf_net_can_delete xf_net_delete xf_net_get xf_net_get_all xf_net_select_all xf_net_update xf_net_validate
set STDOPTS=-e -r -i %ROOT%..\Templates\xfServerPlus -o %ROOT% -ut XF_INTERFACE=MyApi XF_ELB=EXE:xfplMethods -lf

codegen -s %STRUCTURES% -a %ALIASES% -t %TEMPLATES% %STDOPTS%

endlocal
popd