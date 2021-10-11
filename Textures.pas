{Textures v1.0 28.01.2000 by ArrowSoft-VMP}

unit Textures;

interface
type
     TColorRGB = packed record
               r, g, b	: BYTE;
               end;
     PColorRGB = ^TColorRGB;

     TRGBList = packed array[0..0] of TColorRGB;
     PRGBList = ^TRGBList;

     TColorRGBA = packed record
               r, g, b, a : BYTE;
               end;
     PColorRGBA = ^TColorRGBA;

     TRGBAList = packed array[0..0] of TColorRGBA;
     PRGBAList = ^TRGBAList;

     TTexture=class(tobject)
      ID, width, height:integer;
      pixels: pRGBlist;
      constructor Load(tID:integer;filename:string);
      destructor destroy; override;
     end;

     TVoidTexture=class(tobject)
      ID, width, height:integer;
      pixels: pRGBlist;
      constructor create(tid, twidth, theight:integer);
      destructor destroy; override;
     end;

     TTextureRGBA= class(TTexture)
      pixels: pRGBAlist;
     end;

     TVoidTextureRGBA=class(tobject)
      ID, width, height:integer;
      pixels: pRGBAlist;
      constructor create(tid, twidth, theight:integer);
      destructor destroy; override;
     end;


implementation
uses dialogs, sysutils, graphics, jpeg;

constructor tTexture.Load(tID:integer; filename:string);
var f:file;
    dims: array[0..3] of byte;
    actread:integer;
    fext:string;
    bmp:tbitmap; jpg:tjpegimage;
    i,j:integer;
    pixline: pRGBlist;
    r,g,b:byte;

begin
inherited create;
if not fileexists(filename) then begin messagedlg(filename+' not found',mterror,[mbabort],0); halt(1);end;
fExt:=uppercase(ExtractFileExt(filename));
ID:=tID;
if fext='.RGBA' then
 begin
 assign(f,filename);
 {$i-}
 reset(f,4);
 blockread(f,dims,1);
 {$i+}
 if ioresult<>0 then begin messagedlg(filename+' not found',mterror,[mbabort],0); halt(1);end;
 Width:=dims[0]+dims[1]*256; Height:=dims[2]+dims[3]*256;
 getmem(pixels,(filesize(f)-1)*4);
 blockread(f,pixels^,width*height,actread);
 closefile(f);
 end
else
if fext='.RGB' then
 begin
 assign(f,filename);
 {$i-}
 reset(f,1);
 blockread(f,dims,4);
 {$i+}
 if ioresult<>0 then begin messagedlg(filename+' not found',mterror,[mbabort],0); halt(1);end;
 Width:=dims[0]+dims[1]*256; Height:=dims[2]+dims[3]*256;
 getmem(pixels,filesize(f)-4);
 blockread(f,pixels^,width*height*3,actread);
 closefile(f);
 end
else
if fext='.BMP' then
 begin
 bmp:=TBitmap.Create;
 bmp.HandleType:=bmDIB;
 bmp.PixelFormat:=pf24bit;
 bmp.LoadFromFile(filename);
 Width:=bmp.Width;
 Height:=bmp.Height;
 getmem(pixels,width*height*3);
 for i:=0 to height-1 do
  begin
  pixline:=bmp.ScanLine[i];
  for j:=0 to width-1 do
   begin
   r:=pixline[j].b;
   g:=pixline[j].g;
   b:=pixline[j].r;
   pixels[i*width+j].r:=r;
   pixels[i*width+j].g:=g;
   pixels[i*width+j].b:=b;
   end;
  end;
 bmp.Free;
 end
else
if fext='.JPG' then
 begin
 jpg:=tjpegimage.Create;
 jpg.LoadFromFile(filename);
 bmp:=TBitmap.Create;
 bmp.HandleType:=bmDIB;
 bmp.PixelFormat:=pf24bit;
 Width:=jpg.Width;
 Height:=jpg.Height;
 bmp.Width:=Width;
 bmp.Height:=Height;
 bmp.Assign(jpg);
 getmem(pixels,width*height*3);
 for i:=0 to height-1 do
  begin
  pixline:=bmp.ScanLine[i];
  for j:=0 to width-1 do
   begin
   r:=pixline[j].b;
   g:=pixline[j].g;
   b:=pixline[j].r;
   pixels[i*width+j].r:=r;
   pixels[i*width+j].g:=g;
   pixels[i*width+j].b:=b;
   end;
  end;
 bmp.Free;
 jpg.Free;
 end;
end;

destructor TTexture.destroy;
begin
freemem(pixels);
inherited destroy;
end;

constructor tvoidtexture.create(tid, twidth, theight:integer);
begin
inherited create;
id:=tid;
width:=twidth; height:=theight;
getmem(pixels,width*height*3);
end;

destructor tvoidtexture.destroy;
begin
freemem(pixels);
inherited destroy;
end;

constructor tvoidtextureRGBA.create(tid, twidth, theight:integer);
begin
inherited create;
id:=tid;
width:=twidth; height:=theight;
getmem(pixels,width*height*4);
end;

destructor tvoidtextureRGBA.destroy;
begin
freemem(pixels);
inherited destroy;
end;


end.
