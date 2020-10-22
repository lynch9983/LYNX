unit doAPI;

interface

uses
  System.SysUtils;

//中间件设置原文件路径函数
procedure doSetModuleFileName(const aModuleFileName: string); stdcall;
//中间件初始化函数
procedure doInit; stdcall;
//中间件释放函数
procedure doFree; stdcall;
//中间件处理函数
function doSomething(const aCtxt: THandle): Integer; stdcall;

exports
  doSetModuleFileName,
  doInit,
  doFree,
  doSomething;

implementation

uses
  smo.Inter.HttpServer, smo.Inter.Log;

function doPost_formdata(Request: TSmoHttpRequest; Response: TSmoHttpResponse): Integer;
var
  aMultiPart: TMultiPart;
  aMultiPartArray: TMultiPartArray;
begin
  if Request.ParseMultiPartFormData(aMultiPartArray) then
  begin
    for aMultiPart in aMultiPartArray do
    begin
      if aMultiPart.IsFile then
        TSmoLogInter.WriteDebug('[文件] ' + aMultiPart.Name + ': ' + aMultiPart.FileName)
      else
        TSmoLogInter.WriteDebug('[参数] ' + aMultiPart.Name + ': ' + UTF8Decode(aMultiPart.Content));
    end;

    Result := Response.SendText('收到 form-data');
  end
  else
  begin
    Result := Response.SendText('你发送的 form-data 不合法');
  end;
end;

function doSomething(const aCtxt: THandle): Integer;
var
  Request: TSmoHttpRequest;
  Response: TSmoHttpResponse;
begin
  Request  := TSmoHttpRequest.Create(aCtxt);
  Response := TSmoHttpResponse.Create(aCtxt);
  try
    TSmoLogInter.WriteDebug(Request.URL);

    if SameText(Request.Method, 'POST') and SameText(Request.URL, '/httpapi/post/form-data') then
      Result := doPost_formdata(Request, Response)
    else
      Result := 404;




    //Result := Response.SendText('ok,' + aQuery.FieldByName('userName').AsString);

  finally
    Request.Free;
    Response.Free;
  end;
end;

procedure doSetModuleFileName(const aModuleFileName: string);
begin

end;

procedure doInit;
begin

end;

procedure doFree;
begin

end;

end.
