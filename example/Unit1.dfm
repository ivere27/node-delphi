object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 552
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 402
    Height = 337
    Lines.Strings = (
      #39'use strict'#39
      ''
      'var num = 42;'
      'var foo = '#39'foo'#39';'
      ''
      'toby.on('#39'test'#39', function(x){'
      '  toby.hostCall('#39'echo'#39' , x);'
      '});'
      ''
      'var result = toby.hostCall('#39'dory'#39', {num, foo});'
      'console.log(`node :: toby.hostCall() = ${result}`);'
      ''
      'var http = require('#39'http'#39');'
      'var req = http.get('#39'http://google.com'#39', function (res) {'
      '  var chunk = '#39#39';'
      '  res.on('#39'data'#39', function(d){ chunk += d;})'
      '  res.on('#39'end'#39', function(){'
      '    console.log(chunk);'
      '  });'
      '});'
      'req.end();'
      ''
      'setInterval(function(){},1000); // dummy loop')
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 8
    Top = 382
    Width = 402
    Height = 163
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 351
    Width = 75
    Height = 25
    Caption = 'init node.js'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 89
    Top = 351
    Width = 75
    Height = 25
    Caption = 'emit '#39'test'#39
    TabOrder = 3
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 312
    Top = 352
  end
end
