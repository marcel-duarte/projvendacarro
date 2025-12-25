unit uLib;

interface

uses
  System.SysUtils, System.StrUtils;

function Date_to_SQLDate(pData: string): string;
function ValidarCPF(const AValue: string): Boolean;

implementation

function Date_to_SQLDate(pData: string): string;
begin
  Result := Copy(pData,1,2)+'.'+Copy(pData,4,2)+'.'+Copy(pData,7,4);
end;

function ValidarCPF(const AValue: string): Boolean;
var
  CPF: string;
  i, Soma, Resto, Digito1, Digito2: Integer;
  Peso: Integer;

  // Função interna para limpar string
  function ApenasNumeros(const S: string): string;
  var
    C: Char;
  begin
    Result := '';
    for C in S do
    begin
      if CharInSet(C, ['0'..'9']) then
        Result := Result + C;
    end;
  end;

begin
  // 1. Remove caracteres não numéricos
  CPF := ApenasNumeros(AValue);

  // 2. Verifica tamanho
  if Length(CPF) <> 11 then
    Exit(False);

  // 3. Verifica se todos os dígitos são iguais (ex: 111.111.111-11)
  // Isso é necessário pois eles passam no cálculo matemático, mas são inválidos
  if (CPF = StringOfChar(CPF[1], 11)) then
    Exit(False);

  try
    // 4. Calcula o Primeiro Dígito Verificador
    Soma := 0;
    Peso := 10;
    for i := 1 to 9 do
    begin
      Soma := Soma + (StrToInt(CPF[i]) * Peso);
      Dec(Peso);
    end;

    Resto := Soma mod 11;
    if (Resto < 2) then
      Digito1 := 0
    else
      Digito1 := 11 - Resto;

    // 5. Calcula o Segundo Dígito Verificador
    Soma := 0;
    Peso := 11;
    for i := 1 to 10 do
    begin
      Soma := Soma + (StrToInt(CPF[i]) * Peso);
      Dec(Peso);
    end;

    Resto := Soma mod 11;
    if (Resto < 2) then
      Digito2 := 0
    else
      Digito2 := 11 - Resto;

    // 6. Verifica se os dígitos calculados batem com os informados
    Result := (IntToStr(Digito1) = CPF[10]) and (IntToStr(Digito2) = CPF[11]);

  except
    // Em caso de erro de conversão (muito raro após a limpeza), retorna falso
    Result := False;
  end;
end;

end.
