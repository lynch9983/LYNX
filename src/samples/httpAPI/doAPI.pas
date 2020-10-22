unit doAPI;

interface

uses
  System.SysUtils;

//�м������ԭ�ļ�·������
procedure doSetModuleFileName(const aModuleFileName: string); stdcall;
//�м����ʼ������
procedure doInit; stdcall;
//�м���ͷź���
procedure doFree; stdcall;
//�м��������
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
        TSmoLogInter.WriteDebug('[�ļ�] ' + aMultiPart.Name + ': ' + aMultiPart.FileName)
      else
        TSmoLogInter.WriteDebug('[����] ' + aMultiPart.Name + ': ' + UTF8Decode(aMultiPart.Content));
    end;

    Result := Response.SendText('�յ� form-data');
  end
  else
  begin
    Result := Response.SendText('�㷢�͵� form-data ���Ϸ�');
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
