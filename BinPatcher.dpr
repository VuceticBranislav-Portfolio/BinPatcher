program BinPatcher;

(*----------------------------------------------------------------------------------------

Author  : Branislav Vucetic
Version : v1.1
Date    : 01.05.2020
Licence : CC0 1.0

Description :
    BinPatcher help to investigate patcher file format (*.bin). Program list all pathes
    in file. Represent data in table and provide sorting. File can be reloaded anytime.
    BinPatcher can be started by dropping file on desktop icon.

Revision :
    v1.0 - Initial version
    v1.1 - Program remake. Added some features.

------------------------------------------------------------------------------------------

BinPatcher by Branislav Vucetic

To the extent possible under law, the person who associated CC0 with
BinPatcher has waived all copyright and related or neighboring rights
to BinPatcher.

You should have received a copy of the CC0 legalcode along with this
work. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

----------------------------------------------------------------------------------------*)

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBinPatch, BinPatch);
  Application.Run;
end.
