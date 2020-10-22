unit smo.Inter.Log;

interface

type
  //日志操作接口类
  TSmoLogInter = class
  public
    //写日志(DEBUG)
    class procedure WriteDebug(const aText: string);
    //写日志(信息)
    class procedure WriteInfo(const aText: string);
    //写日志(错误)
    class procedure WriteError(const aText: string);
  end;

const
  DLL_SYSTEM_INTER = 'system_api.dll';

  procedure Sys_Log_WriteDebug(const aText: string); stdcall; external DLL_SYSTEM_INTER;
  procedure Sys_Log_WriteInfo(const aText: string); stdcall; external DLL_SYSTEM_INTER;
  procedure Sys_Log_WriteError(const aText: string); stdcall; external DLL_SYSTEM_INTER;

implementation

{ TSmoLogInter }
class procedure TSmoLogInter.WriteDebug(const aText: string);
begin
  Sys_Log_WriteDebug(aText);
end;

class procedure TSmoLogInter.WriteError(const aText: string);
begin
  Sys_Log_WriteInfo(aText);
end;

class procedure TSmoLogInter.WriteInfo(const aText: string);
begin
  Sys_Log_WriteError(aText);
end;

end.
