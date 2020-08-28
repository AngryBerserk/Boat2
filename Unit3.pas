unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Math, Vcl.ExtCtrls, System.Generics.Collections;

const
  maxSize=1500;
  border=10;

type
  TCanvasDrawer = class
    Back:TBitmap;
    SL:Array of PByteArray;
    constructor Create(const w,h:Word);
    procedure Draw(const x,y:Word; const C:TColor);
    procedure Swap(C:TCanvas);
  end;
  TParticle = class
    posX,
    posY:Real;
    ang:Real;
    speed:Real;
    size:real;
    anginc:Real;
    bounce:Boolean;
    color:TColor;
    dcb:byte;
    constructor Create(const x,y,a,si,sp:Real);
    procedure move;
    procedure Normal;
    procedure Draw(C:TCanvasDrawer);
  end;
  TForm3 = class(TForm)
    Timer1: TTimer;
    Shape1: TShape;
    BonusTimer: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    PA:TPArticle;
    PL:TList<TParticle>;
    dc:Real;
    CaDr:TCanvasDrawer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

constructor TParticle.Create(const x,y,a,si,sp:Real);
begin
  posX:=x;
  posY:=y;
  speed:=sp;
  ang:=DegToRad(a);
  size:=si;
  anginc:=DegToRad(0);
  bounce:=false;
end;

procedure TParticle.normal;
Begin
  if (posx<border)or(posx>form3.clientwidth-border) then ang:=Pi-ang else
  if (posy<border)or(posy>form3.clientheight-border) then ang:=-1*ang
End;

procedure TParticle.move;
begin
  posx:=posX+cos(ang)*speed;
  posy:=posy-sin(ang)*speed;
  ang:=ang+anginc;
  if (posx<border+speed)or
     (posx>form3.clientwidth-border-speed)or
     (posy<border+speed)or
     (posy>form3.clientheight-border-speed)
      then
        Begin
          Normal;
          bounce:=true;
        End;
   if size>0 then
    size:=size-1;
   dcb:=round(size*form3.dc);
   Color:=RGB(dcb+50,dcb+50,255);
   //CaDr.Draw(Round(P.posX),Round(P.posY),dcb+50,dcb+50,255);
end;

procedure TParticle.Draw(C: TCanvasDrawer);
 var px,py:Real;
begin
  C.Draw(round(posX),Round(posY),Color);
  C.Draw(round(posX),Round(posY),Color);
  {
  px:=posX+cos(ang-pi);
  py:=posy-sin(ang-pi);
  C.Draw(round(pX),Round(pY),RGB(GetRValue(Color)-20,GetGValue(Color)-20,GetBValue(Color)));
  px:=posX+cos(ang+pi);
  py:=posy-sin(ang+pi);
  C.Draw(round(pX),Round(pY),RGB(GetRValue(Color)-20,GetGValue(Color)-20,GetBValue(Color)));

  px:=posX+cos(ang-pi)*2;
  py:=posy-sin(ang-pi)*2;
  C.Draw(round(pX),Round(pY),RGB(GetRValue(Color)-40,GetGValue(Color)-40,GetBValue(Color)));
  px:=posX+cos(ang+pi)*2;
  py:=posy-sin(ang+pi)*2;
  C.Draw(round(pX),Round(pY),RGB(GetRValue(Color)-40,GetGValue(Color)-40,GetBValue(Color)));
  }
end;

constructor TCanvasDrawer.Create(const w,h:Word);
 var z:Word;
begin
  Back:=TBitmap.Create;
  Back.Width:=w;
  Back.Height:=h;
  Back.PixelFormat:=pf24bit;
  Back.Canvas.Brush.Color:=RGB(50,50,255);
  SetLength(SL,h);
  for z := 0 to h-1 do
    SL[z]:=Back.ScanLine[z];
end;

procedure TCanvasDrawer.Draw(const x: Word; const y: Word; const C:TColor);
begin
     SL[Y][X*3]:=GetBValue(C);      //b            //50,50,255
     SL[Y][X*3+1]:=GetGValue(C);    //g
     SL[Y][X*3+2]:=GetRValue(C);    //r
end;

procedure TCanvasDrawer.Swap(C: TCanvas);
begin
  C.Draw(0,0,Back);
  Back.Canvas.FillRect(Rect(0,0,Back.Width,Back.Height));
end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if KEY=VK_LEFT then PA.anginc:=PA.anginc+DegToRad(0.2);
  if KEY=VK_RIGHT then PA.anginc:=PA.anginc-DegToRad(0.2);
  if KEY=VK_UP then PA.speed:=PA.speed+0.1;
  if KEY=VK_DOWN then PA.speed:=PA.speed-0.1;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  dc:=(255-50)/(maxSize-3);
  PL:=TList<TPArticle>.Create;
  CaDr:=TCanvasDrawer.Create(ClientWidth,ClientHeight);
  PA:=TPArticle.Create(clientwidth div 2, clientheight div 2, 90 , -1,1);
end;

procedure TForm3.Timer1Timer(Sender: TObject);
 var P:TPArticle;
begin
 PA.move;
 if not PA.bounce then
    Begin
     PL.Add(TParticle.Create(PA.posX,PA.posY,RadToDeg(PA.ang)-127,maxSize,0.2));
     PL.Add(TParticle.Create(PA.posX,PA.posY,RadToDeg(PA.ang)+127,maxSize,0.2));
    End;
 PA.bounce:=false;
 CaDr.Back.Canvas.Ellipse(round(PA.posX-3),round(PA.posY-3),round(PA.posX+3),round(PA.posY+3));
 for P in PL do
   Begin
     P.move;
     P.Draw(CaDr);
   End;
 CaDr.Swap(Canvas);
 for P in PL do
  if P.size<=3 then PL.Remove(P)

end;

end.
