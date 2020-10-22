unit smo.Inter.HttpServer;

interface

uses
  SysUtils, Classes
{$IFDEF SMO_JSON}
  ,smo.JsonDataObjects
{$ENDIF SMO_JSON}
{$IFDEF SMO_RVAR}
  ,smo.VarType
{$ENDIF SMO_RVAR}
  ;

type
  //上传文件类
  TUpdateFile = record
    Name: string;
    FileName: string;
    ContentType: string;
    Encoding: string;
    Content: RawByteString;

    procedure SaveToFile(const aFileName:string);
  end;
  TUpdateFileArray = array of TUpdateFile;


  TMultiPart = record
    Name: string;
    FileName: string;
    ContentType: string;
    Encoding: string;
    Content: RawByteString;

    function IsFile: Boolean;
    procedure SaveToFile(const aFileName:string);
  end;
  TMultiPartArray = array of TMultiPart;

  //头参数列表
  THeaders = class
  private
    FItems: TStringList;

    function GetText: string;
    procedure SetText(const Value: string);
    function GetCount: Integer;
    function GetName(Index: Integer): string;
    function GetValue(const Name: string): string;
    procedure SetValue(const Name, Value: string);
    function GetValueFromIndex(Index: Integer): string;
    procedure SetValueFromIndex(Index: Integer; const Value: string);
  public
    constructor Create; overload;
    constructor Create(const aDataString: string); overload;
    destructor Destroy; override;

    procedure Clear;
    procedure Delete(const aIndex: Integer);
    function IndexOfName(const Name: string): Integer;
    function ToStringList: TStringList;

    property Text: string read GetText write SetText;
    property Count: Integer read GetCount;
    property Names[Index: Integer]: string read GetName;
    property Values[const Name: string]: string read GetValue write SetValue;
    property ValueFromIndex[Index: Integer]: string read GetValueFromIndex write SetValueFromIndex;
  end;

  //参数列表
  TParams = class
  private
    FItems: TStringList;

    function GetText: string;
    procedure SetText(const Value: string);
    function GetCount: Integer;
    function GetName(Index: Integer): string;
    function GetValue(const Name: string): string;
    procedure SetValue(const Name, Value: string);
    function GetValueFromIndex(Index: Integer): string;
    procedure SetValueFromIndex(Index: Integer; const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Delete(const aIndex: Integer);
    function IndexOfName(const Name: string): Integer;
    function ToStringList: TStringList;

    property Text: string read GetText write SetText;
    property Count: Integer read GetCount;
    property Names[Index: Integer]: string read GetName;
    property Values[const Name: string]: string read GetValue write SetValue;
    property ValueFromIndex[Index: Integer]: string read GetValueFromIndex write SetValueFromIndex;
  end;

  //Http请求操作接口类
  TSmoHttpRequest = class
  private
    FHandle: THandle;   //句柄
    FHeaders: THeaders; //请求头
    FParams: TParams;   //请求参数列表

    FURL: string;       //请求URL
    FMethod: string;    //请求方法
    FSID: string;       //会话ID
{$IFDEF SMO_JSON}
    FContentJson: TJsonBaseObject;
{$ENDIF SMO_JSON}

    function GetWebRoot: string;
    function GetRouteRoot: string;
    function GetURL: string;
    function GetUseSSL: Boolean;
    function GetMethod: string;
    function GetSID: string;
    function GetUserAgent: string;
    function GetXFF: string;
    function GetRemoteIP: string;
    function GetRealIP: string;
    function GetHost: string;
{$IFDEF SMO_JSON}
    function GetContentJson: TJsonBaseObject;
{$ENDIF SMO_JSON}
    function GetContent: string;
    function GetContentType: string;
    function GetHeaders: THeaders;
    function GetParams: TParams;
{$IFDEF SMO_RVAR}
    function GetParamAsRBoolean(const aName: string): RBoolean;
    function GetParamAsRInteger(const aName: string): RInteger;
    function GetParamAsRDouble(const aName: string): RDouble;
    function GetParamAsRString(const aName: string): RString;
    function GetParamAsRDateTime(const aName: string): RDateTime;
{$ENDIF SMO_RVAR}
    function GetUpdateFiles: TUpdateFileArray;
  public
    constructor Create(const aCtxt: THandle);
    destructor Destroy; override;

    property WebRoot: string read GetWebRoot;
    property RouteRoot: string read GetRouteRoot;
    property URL: string read GetURL;
    property UseSSL: Boolean read GetUseSSL;
    property Method: string read GetMethod;
    property SID: string read GetSID;
    property UserAgent: string read GetUserAgent;
    property XFF: string read GetXFF;
    property RemoteIP: string read GetRemoteIP;
    property RealIP: string read GetRealIP;
    property Host: string read GetHost;

{$IFDEF SMO_JSON}
    property ContentJson: TJsonBaseObject read GetContentJson;
{$ENDIF SMO_JSON}
    property Content: string read GetContent;
    property ContentType: string read GetContentType;
    property Headers: THeaders read GetHeaders;
    property Params: TParams read GetParams;
{$IFDEF SMO_RVAR}
    property ParamRB[const aName: string]: RBoolean read GetParamAsRBoolean;
    property ParamRI[const aName: string]: RInteger read GetParamAsRInteger;
    property ParamRD[const aName: string]: RDouble read GetParamAsRDouble;
    property ParamRS[const aName: string]: RString read GetParamAsRString;
    property ParamRT[const aName: string]: RDateTime read GetParamAsRDateTime;
{$ENDIF SMO_RVAR}
    property UpdateFiles: TUpdateFileArray read GetUpdateFiles;

    function ParseMultiPartFormData(var aMultiPartArray: TMultiPartArray): Boolean;
  end;

  //Http应答操作接口类
  TSmoHttpResponse = class
  private
    FHandle: THandle;   //句柄
    FHeaders: THeaders; //请求头

    function GetContent: string;
    procedure SetContent(const Value: string);
    function GetContentType: string;
    procedure SetContentType(const Value: string);
    function GetHeaders: THeaders;
  public
    constructor Create(const aCtxt: THandle);
    destructor Destroy; override;

{$IFDEF SMO_JSON}
    //发送JSON对象
    function SendJson(const aJson: TJsonBaseObject): Integer;
{$ENDIF SMO_JSON}
    //发送流
    function SendStream(const aStream: TStream): Integer;
    //发送文本
    function SendText(const aText: string): Integer;
    //发送网页
    function SendHtml(const aHtml: string): Integer;
    //发送文件
    function SendFile(const aFileName: string): Integer;
    //发送文件(下载)
    function SendFileForDownload(const aSourceFileName: string; const aDisplayFileName: string = ''): Integer;
    //返回错误页面,例如404等
    function SendError(const aErrCode: Integer; const aErrInfo: string = ''): Integer;
    //重定向
    function Location(const aURL: string; const aStatus: Integer = 302): Integer;

    property Content: string read GetContent write SetContent;
    property ContentType: string read GetContentType write SetContentType;
    property Headers: THeaders read GetHeaders;
  end;

const
  STATUS_CODE_200 = 200; //表示已在相应中发出.
  STATUS_CODE_202 = 202; //已接受请求但尚未完成,异步处理.
  STATUS_CODE_302 = 302; //请求临时跳转.
  STATUS_CODE_400 = 400; //请求参数错误.
  STATUS_CODE_401 = 401; //认证失败,可能会话失效.
  STATUS_CODE_404 = 404; //找不到请求的网页.
  STATUS_CODE_500 = 500; //服务端操作异常.

const
  CONTENT_TYPE_FORM = 'application/x-www-form-urlencoded';
  CONTENT_TYPE_JSON = 'application/json; charset=UTF-8';
  CONTENT_TYPE_TEXT = 'text/plain; charset=UTF-8';
  CONTENT_TYPE_HTML = 'text/html; charset=UTF-8';

const
  DLL_SYSTEM_INTER = 'system_api.dll';
  //Base
  function Sys_HttpServer_GetWebRoot: string; stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_GetRouteRoot: string; stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_GetFileMIMEType(const aFileName: string): string; stdcall; external DLL_SYSTEM_INTER;
  //Request
  function Sys_HttpServer_GetRequestURL(const aCtxt: THandle): UTF8String; stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_GetRequestMethod(const aCtxt: THandle): UTF8String; stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_GetRequestUseSSL(const aCtxt: THandle): Boolean; stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_GetRequestHeaders(const aCtxt: THandle): UTF8String; stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_GetRequestContent(const aCtxt: THandle): UTF8String; stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_GetRequestContentType(const aCtxt: THandle): UTF8String; stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_GetRequestUpdateFiles(const aCtxt: THandle; var aFileArray: TUpdateFileArray): Boolean; stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_ParseMultiPartFormData(const aCtxt: THandle; var aMultiPartArray: TMultiPartArray): Boolean; stdcall; external DLL_SYSTEM_INTER;
  //Response
  function Sys_HttpServer_GetResponseHeaders(const aCtxt: THandle): UTF8String; stdcall; external DLL_SYSTEM_INTER;
  procedure Sys_HttpServer_SetResponseHeaders(const aCtxt: THandle; const aHeaders: UTF8String); stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_GetResponseContent(const aCtxt: THandle): UTF8String; stdcall; external DLL_SYSTEM_INTER;
  procedure Sys_HttpServer_SetResponseContent(const aCtxt: THandle; const aContent: UTF8String); stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_GetResponseContentType(const aCtxt: THandle): UTF8String; stdcall; external DLL_SYSTEM_INTER;
  procedure Sys_HttpServer_SetResponseContentType(const aCtxt: THandle; const aContentType: UTF8String); stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_SendFile(const aCtxt: THandle; const aFileName: string): Cardinal; stdcall; external DLL_SYSTEM_INTER;
  function Sys_HttpServer_SendFileForDownload(const aCtxt: THandle; const aSourceFileName: string; const aDisplayFileName: string): Cardinal; stdcall; external DLL_SYSTEM_INTER;

implementation

{ TMultiPart }
function TMultiPart.IsFile: Boolean;
begin
  Result := FileName <> '';
end;

procedure TMultiPart.SaveToFile(const aFileName:string);
var
  aStream: TFileStream;
begin
  aStream := TFileStream.Create(aFileName, fmCreate or fmShareDenyWrite);
  try
    aStream.Write(Content[1], Length(Content));
  finally
    aStream.Free;
  end;
end;

{ TUpdateFile }
procedure TUpdateFile.SaveToFile(const aFileName: string);
var
  aStream: TFileStream;
begin
  aStream := TFileStream.Create(aFileName, fmCreate or fmShareDenyWrite);
  try
    aStream.Write(Content[1], Length(Content));
  finally
    aStream.Free;
  end;
end;

{ THeaders }
constructor THeaders.Create;
begin
  FItems := TStringList.Create;
  FItems.NameValueSeparator := ':';
end;

constructor THeaders.Create(const aDataString: string);
begin
  FItems := TStringList.Create;
  FItems.NameValueSeparator := ':';
  FItems.Text := aDataString;
end;

destructor THeaders.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure THeaders.Clear;
begin
  FItems.Clear;
end;

procedure THeaders.Delete(const aIndex: Integer);
begin
  FItems.Delete(aIndex);
end;

function THeaders.IndexOfName(const Name: string): Integer;
begin
  Result := FItems.IndexOfName(Name);
end;

function THeaders.ToStringList: TStringList;
begin
  Result := FItems;
end;

function THeaders.GetText: string;
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    if Pos(' ', FItems.ValueFromIndex[i]) <> 1 then
       FItems.ValueFromIndex[i] := ' ' + FItems.ValueFromIndex[i];

  Result := FItems.Text;
end;

procedure THeaders.SetText(const Value: string);
var
  i: Integer;
begin
  FItems.Text := Value;

  for i := 0 to FItems.Count - 1 do
    if Pos(' ', FItems.ValueFromIndex[i]) <> 1 then
       FItems.ValueFromIndex[i] := ' ' + FItems.ValueFromIndex[i];
end;

function THeaders.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function THeaders.GetName(Index: Integer): string;
begin
  Result := FItems.Names[Index];
end;

function THeaders.GetValue(const Name: string): string;
begin
  Result := FItems.Values[Name];
  if Pos(' ', Result) = 1 then
    Result := Copy(Result, 2, MaxInt);
end;

procedure THeaders.SetValue(const Name, Value: string);
begin
  FItems.Values[Name] := ' ' + Value;
end;

function THeaders.GetValueFromIndex(Index: Integer): string;
begin
  Result := FItems.ValueFromIndex[Index];
  if Pos(' ', Result) = 1 then
    Result := Copy(Result, 2, MaxInt);
end;

procedure THeaders.SetValueFromIndex(Index: Integer; const Value: string);
begin
  FItems.ValueFromIndex[Index] := ' ' + Value;
end;

{ TParams }
constructor TParams.Create;
begin
  FItems := TStringList.Create;
end;

destructor TParams.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TParams.Clear;
begin
  FItems.Clear;
end;

procedure TParams.Delete(const aIndex: Integer);
begin
  FItems.Delete(aIndex);
end;

function TParams.IndexOfName(const Name: string): Integer;
begin
  Result := FItems.IndexOfName(Name);
end;

function TParams.ToStringList: TStringList;
begin
  Result := FItems;
end;

function TParams.GetText: string;

  function StrToHex(const s: AnsiString): AnsiString;
  var
    Len, i: Integer;
    C, H, L: Byte;

    function HexChar(N : Byte) : AnsiChar;
    begin
      if (N < 10) then
        Result := AnsiChar(Chr(Ord('0') + N))
      else
        Result := AnsiChar(Chr(Ord('A') + (N - 10)));
    end;

  begin
    Len := Length(s);
    SetLength(Result, Len shl 1);
    for i := 1 to Len do
    begin
      C := Ord(s[i]);
      H := (C shr 4) and $f;
      L := C and $f;
      Result[i shl 1 - 1] := HexChar(H);
      Result[i shl 1] := HexChar(L);
    end;
  end;

  function Str2HTML(const Str: AnsiString): AnsiString;
  var
    i: Integer;
    c: AnsiChar;
    s: AnsiString;
  begin
    Result := '';
    for i := 1 to Length(Str) do
    begin
      c := Str[i];
      case c of
       '0'..'9', 'A'..'Z', 'a'..'z', '.', '-': Result := Result + c;
        else
        begin
          s := c;
          Result := Result + '%' + StrToHex(s);
        end
      end;
    end;
  end;

var
  i: Integer;
begin
  Result := '';
  for i := 0 to FItems.Count - 1 do
  begin
    if i = 0 then
      Result := string(Str2HTML(Utf8Encode(FItems.Names[i]))) + '=' +
                string(Str2HTML(Utf8Encode(FItems.ValueFromIndex[i])))
    else
      Result := Result + '&' + string(Str2HTML(Utf8Encode(FItems.Names[i]))) + '=' +
                               string(Str2HTML(Utf8Encode(FItems.ValueFromIndex[i])));
  end;
end;

procedure TParams.SetText(const Value: string);

  function HexToStr(const s: AnsiString): AnsiString;
  var
    Len, i: Integer;
    C, H, L: Byte;

    function CharHex(C: AnsiChar): Byte;
    begin
      C := UpCase(C);
      if (C <= '9') then
        Result := Ord(C) - Ord('0')
      else
        Result := Ord(C) - Ord('A') + 10;
    end;

  begin
    Len := Length(s);
    SetLength(Result, Len shr 1);
    for i := 1 to Len shr 1 do
    begin
      H := CharHex(s[i shl 1 - 1]);
      L := CharHex(s[i shl 1]);
      C := H shl 4 or L;
      Result[i] := AnsiChar(Chr(C));
    end;
  end;

  function HTML2Str(const Line: AnsiString): AnsiString;
  var
    i: Integer;
    s, buf: AnsiString;
  begin
    Result := Line;
    if Length(Result) > 0 then
    begin
      i := 1;
      while i <= Length(Result) do
      begin
        if Result[i] = '%' then
        begin
          if i <= Length(Result) - 2 then
          begin
            s := Result[i + 1] + Result[i + 2];
            buf := HexToStr(s);
            System.Delete(Result, i, 2);
            Result[i] := buf[1];
          end
        end
        else
        if Result[i] = '+' then
          Result[i] := ' ';
        i := i + 1;
      end;
    end;
  end;

var
  i: Integer;
  tmpParams: TStringList;
begin
  if Value <> '' then
  begin
    tmpParams := TStringList.Create;
    try
      tmpParams.Delimiter := '&';
      tmpParams.StrictDelimiter := True;
      tmpParams.DelimitedText := Value;
      for i := 0 to tmpParams.Count - 1 do
        FItems.Add(UTF8ToString(HTML2Str(AnsiString(tmpParams.Strings[i]))));
    finally
      tmpParams.Free;
    end;
  end;
end;

function TParams.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TParams.GetName(Index: Integer): string;
begin
  Result := FItems.Names[Index];
end;

function TParams.GetValue(const Name: string): string;
begin
  Result := FItems.Values[Name];
end;

procedure TParams.SetValue(const Name, Value: string);
begin
  FItems.Values[Name] := Value;
end;

function TParams.GetValueFromIndex(Index: Integer): string;
begin
  Result := FItems.ValueFromIndex[Index];
end;

procedure TParams.SetValueFromIndex(Index: Integer; const Value: string);
begin
  FItems.ValueFromIndex[Index] := Value;
end;

{ TSmoHttpRequest }
constructor TSmoHttpRequest.Create(const aCtxt: THandle);

  procedure GetInfoByURL(const aStr: UTF8String;
                         var aURL: string;
                         var aSID: string);
  var
    aPos_P: Integer;
    aPos_S: Integer;
  begin
    aURL := UTF8ToString(aStr);
    aSID := '';
    aPos_P := Pos('?', aURL);
    aPos_S := Pos(';sid=', LowerCase(aURL));
    if (aPos_P > 0) or (aPos_S > 0) then
    begin
      if aPos_P > aPos_S then
      begin
        if aPos_S > 0 then
        begin
          FSID := Copy(aURL, aPos_S + 5, aPos_P - aPos_S - 5);
          aURL := Copy(aURL, 1, aPos_S - 1);
        end
        else
          aURL := Copy(aURL, 1, aPos_P - 1);
      end
      else
      begin
        FSID := Copy(aURL, aPos_S + 5, MaxInt);
        if aPos_P > 0 then
          aURL := Copy(aURL, 1, aPos_P - 1)
        else
          aURL := Copy(aURL, 1, aPos_S - 1);
      end;
    end;
  end;

begin
  FHandle := aCtxt;
  GetInfoByURL(Sys_HttpServer_GetRequestURL(FHandle), FURL, FSID);
end;

destructor TSmoHttpRequest.Destroy;
begin
{$IFDEF SMO_JSON}
  if Assigned(FContentJson) then
    FreeAndNil(FContentJson);
{$ENDIF SMO_JSON}
  if Assigned(FHeaders) then
    FreeAndNil(FHeaders);
  if Assigned(FParams) then
    FreeAndNil(FParams);
  inherited;
end;

function TSmoHttpRequest.GetWebRoot: string;
begin
  Result := Sys_HttpServer_GetWebRoot;
end;

function TSmoHttpRequest.GetRouteRoot: string;
begin
  Result := Sys_HttpServer_GetRouteRoot;
end;

function TSmoHttpRequest.GetURL: string;
begin
  Result := FURL;
end;

function TSmoHttpRequest.GetUseSSL: Boolean;
begin
  Result := Sys_HttpServer_GetRequestUseSSL(FHandle);
end;

function TSmoHttpRequest.GetMethod: string;
begin
  if FMethod = '' then
    FMethod := UTF8ToString(Sys_HttpServer_GetRequestMethod(FHandle));
  Result := FMethod;
end;

function TSmoHttpRequest.GetSID: string;
begin
  Result := FSID;
end;

function TSmoHttpRequest.GetUserAgent: string;
begin
  Result := Self.Headers.Values['User-Agent'];
end;

function TSmoHttpRequest.GetXFF: string;
begin
  Result := Self.Headers.Values['X-Forwarded-For'];
end;

function TSmoHttpRequest.GetRemoteIP: string;
begin
  Result := Self.Headers.Values['RemoteIP'];
end;

function TSmoHttpRequest.GetRealIP: string;

  function GetFirstIP(aIP: string): string;
  var
    aPos: Integer;
  begin
    aIP := Trim(aIP);
    if aIP <> '' then
    begin
      aPos := Pos(', ', aIP);
      if aPos = 0 then
        Result := aIP
      else
        Result := Copy(aIP, 1, aPos - 1);
    end
    else
      Result := '';
  end;

begin
  Result := GetFirstIP(Self.XFF);
  if Result = '' then
    Result := Self.RemoteIP;
end;

function TSmoHttpRequest.GetHost: string;
begin
  Result := Self.Headers.Values['Host'];
end;

function TSmoHttpRequest.ParseMultiPartFormData(var aMultiPartArray: TMultiPartArray): Boolean;
begin
  Result := Sys_HttpServer_ParseMultiPartFormData(FHandle, aMultiPartArray);
end;

{$IFDEF SMO_JSON}
function TSmoHttpRequest.GetContentJson: TJsonBaseObject;
begin
  if not Assigned(FContentJson) then
  begin
    try
      FContentJson := TJsonBaseObject.ParseUtf8(Sys_HttpServer_GetRequestContent(FHandle));
    except
      on E: Exception do
      begin
        raise Exception.Create('TSmoHttpRequest.GetContentJson Error,' + E.Message);
        Result := nil;
        Exit;
      end;
    end;
  end;
  Result := FContentJson;
end;
{$ENDIF SMO_JSON}

function TSmoHttpRequest.GetContent: string;
begin
  Result := UTF8ToString(Sys_HttpServer_GetRequestContent(FHandle));
end;

function TSmoHttpRequest.GetContentType: string;
begin
  Result := UTF8ToString(Sys_HttpServer_GetRequestContentType(FHandle));
end;

function TSmoHttpRequest.GetHeaders: THeaders;
begin
  if not Assigned(FHeaders) then
    FHeaders := THeaders.Create(UTF8ToString(Sys_HttpServer_GetRequestHeaders(FHandle)));
  Result := FHeaders;
end;

function TSmoHttpRequest.GetParams: TParams;

  function GetParamStrByURL(const aStr: UTF8String): string;
  var
    aPos_P: Integer;
    aPos_S: Integer;
  begin
    Result := UTF8ToString(aStr);
    aPos_P := Pos('?', Result);
    if aPos_P > 0 then
    begin
      Result := Copy(Result, aPos_P + 1, MaxInt);
      aPos_S := Pos(';sid=', LowerCase(Result));
      if aPos_S > 0 then
        Result := Copy(Result, 1, aPos_S - 1);
    end
    else
      Result := '';
  end;

var
  aParamStr: string;

begin
  if not Assigned(FParams) then
  begin
    FParams := TParams.Create;
    aParamStr := GetParamStrByURL(Sys_HttpServer_GetRequestURL(FHandle));

    if SameText(Self.ContentType, CONTENT_TYPE_FORM) then
      if Self.Content <> '' then
        if aParamStr <> '' then
          aParamStr := Self.Content
        else
          aParamStr := aParamStr + '&' + Self.Content;

    FParams.Text := aParamStr;
  end;
  Result := FParams;
end;

{$IFDEF SMO_RVAR}
function TSmoHttpRequest.GetParamAsRBoolean(const aName: string): RBoolean;
begin
  Result.Clear;

  if Params.IndexOfName(aName) <> -1 then
    Result := RBoolean.Parse(Params.Values[aName]);
end;

function TSmoHttpRequest.GetParamAsRInteger(const aName: string): RInteger;
begin
  Result.Clear;

  if Params.IndexOfName(aName) <> -1 then
    Result := RInteger.Parse(Params.Values[aName]);
end;

function TSmoHttpRequest.GetParamAsRDouble(const aName: string): RDouble;
begin
  Result.Clear;

  if Params.IndexOfName(aName) <> -1 then
    Result := RDouble.Parse(Params.Values[aName]);
end;

function TSmoHttpRequest.GetParamAsRString(const aName: string): RString;
begin
  Result.Clear;

  if Params.IndexOfName(aName) <> -1 then
    Result := RString.Parse(Params.Values[aName]);
end;

function TSmoHttpRequest.GetParamAsRDateTime(const aName: string): RDateTime;
begin
  Result.Clear;

  if Params.IndexOfName(aName) <> -1 then
    Result := RDateTime.Parse(Params.Values[aName]);
end;
{$ENDIF SMO_RVAR}

function TSmoHttpRequest.GetUpdateFiles: TUpdateFileArray;
begin
  Sys_HttpServer_GetRequestUpdateFiles(FHandle, Result);
end;

{ TSmoHttpResponse }
constructor TSmoHttpResponse.Create(const aCtxt: THandle);
begin
  FHandle := aCtxt;
end;

destructor TSmoHttpResponse.Destroy;
begin
  if Assigned(FHeaders) then
  begin
    Sys_HttpServer_SetResponseHeaders(FHandle, Utf8Encode(FHeaders.Text));
    FreeAndNil(FHeaders);
  end;
  inherited;
end;

function TSmoHttpResponse.GetHeaders: THeaders;
begin
  if not Assigned(FHeaders) then
    FHeaders := THeaders.Create(UTF8ToString(Sys_HttpServer_GetResponseHeaders(FHandle)));
  Result := FHeaders;
end;

function TSmoHttpResponse.GetContent: string;
begin
  Result := UTF8ToString(Sys_HttpServer_GetResponseContent(FHandle));
end;

procedure TSmoHttpResponse.SetContent(const Value: string);
begin
  Sys_HttpServer_SetResponseContent(FHandle, Utf8Encode(Value));
end;

function TSmoHttpResponse.GetContentType: string;
begin
  Result := UTF8ToString(Sys_HttpServer_GetResponseContentType(FHandle));
end;

procedure TSmoHttpResponse.SetContentType(const Value: string);
begin
  Sys_HttpServer_SetResponseContentType(FHandle, Utf8Encode(Value));
end;

{$IFDEF SMO_JSON}
function TSmoHttpResponse.SendJson(const aJson: TJsonBaseObject): Integer;
begin
  Sys_HttpServer_SetResponseContent(FHandle, aJson.ToUtf8JSON);
  Sys_HttpServer_SetResponseContentType(FHandle, CONTENT_TYPE_JSON);
  Result := STATUS_CODE_200;
end;
{$ENDIF SMO_JSON}

function TSmoHttpResponse.SendStream(const aStream: TStream): Integer;

  function StreamToUTF8String(const aStream: TStream): UTF8String;
  begin
    if Assigned(aStream) then
    begin
      SetLength(Result, aStream.Size);
      aStream.Read(Result[1], aStream.Size);
    end
    else
      Result := '';
  end;

begin
  Sys_HttpServer_SetResponseContent(FHandle, StreamToUTF8String(aStream));
  if Sys_HttpServer_GetResponseContentType(FHandle) = '' then
    Sys_HttpServer_SetResponseContentType(FHandle, CONTENT_TYPE_TEXT);
  Result := STATUS_CODE_200;
end;

function TSmoHttpResponse.SendText(const aText: string): Integer;
begin
  Sys_HttpServer_SetResponseContent(FHandle, Utf8Encode(aText));
  Sys_HttpServer_SetResponseContentType(FHandle, CONTENT_TYPE_TEXT);
  Result := STATUS_CODE_200;
end;

function TSmoHttpResponse.SendHtml(const aHtml: string): Integer;
begin
  Sys_HttpServer_SetResponseContent(FHandle, Utf8Encode(aHtml));
  Sys_HttpServer_SetResponseContentType(FHandle, CONTENT_TYPE_HTML);
  Result := STATUS_CODE_200;
end;

function TSmoHttpResponse.SendFile(const aFileName: string): Integer;
begin
  Result := Sys_HttpServer_SendFile(FHandle, aFileName);
end;

function TSmoHttpResponse.SendFileForDownload(const aSourceFileName: string; const aDisplayFileName: string): Integer;
begin
  Result := Sys_HttpServer_SendFileForDownload(FHandle, aSourceFileName, aDisplayFileName);
end;

function TSmoHttpResponse.SendError(const aErrCode: Integer;
                                    const aErrInfo: string): Integer;
  function GetErrorInfo: UTF8String;
  const
    ERROR_FORMAT = 'ERROR %d';
  begin
    if aErrInfo <> '' then
    begin
      Result := Utf8Encode(aErrInfo);
      Exit;
    end;

    case aErrCode of
      STATUS_CODE_400: Result := Utf8Encode('参数格式有错误.');
      STATUS_CODE_401: Result := Utf8Encode('认证失败,可能会话失效.');
      STATUS_CODE_404: Result := Utf8Encode('找不到请求的网页.');
      STATUS_CODE_500: Result := Utf8Encode('服务端操作异常.');
    else
      Result := Utf8Encode(Format(ERROR_FORMAT, [aErrCode]));
    end;
  end;

begin
  Sys_HttpServer_SetResponseContent(FHandle, GetErrorInfo);
  Sys_HttpServer_SetResponseContentType(FHandle, CONTENT_TYPE_HTML);
  Result := aErrCode;
end;

function TSmoHttpResponse.Location(const aURL: string;
                                   const aStatus: Integer): Integer;
begin
  Self.Headers.Values['Location'] := aURL;
  Result := aStatus;
end;

end.
