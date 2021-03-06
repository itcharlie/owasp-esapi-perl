#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 77;

use_ok('OWASP::ESAPI::Codec::HTMLEntityCodec');
use_ok('OWASP::ESAPI::Codec::PercentCodec');
use_ok('OWASP::ESAPI::Codec::JavaScriptCodec');
use_ok('OWASP::ESAPI::Codec::VBScriptCodec');
use_ok('OWASP::ESAPI::Codec::CSSCodec');
# use_ok('OWASP::ESAPI::Codec::MySQLCodec');
# use_ok('OWASP::ESAPI::Codec::OracleCodec');
# use_ok('OWASP::ESAPI::Codec::UnixCodec');
# use_ok('OWASP::ESAPI::Codec::WindowsCodec');

my $html_codec       = OWASP::ESAPI::Codec::HTMLEntityCodec->new;
my $percent_codec    = OWASP::ESAPI::Codec::PercentCodec->new;
my $javascript_codec = OWASP::ESAPI::Codec::JavaScriptCodec->new;
my $vbscript_codec   = OWASP::ESAPI::Codec::VBScriptCodec->new;
my $css_codec        = OWASP::ESAPI::Codec::CSSCodec->new;

is($html_codec->encode(immune => [], input => 'test'), 'test', 'test HTML encode');
is($percent_codec->encode(immune => [], input => '<'), '%3c', 'test percent encode');
is($javascript_codec->encode(immune => [], input => '<'), '\\x3c', 'test JavaScript encode');
is($vbscript_codec->encode(immune => [], input => '<'), 'chrw(60)', 'test VBScript encode');
is($css_codec->encode(immune => [], input => '<'), '\\3c ', 'test CSS encode');

is($css_codec->decode(input => '\\abcdefg'), "\x{FFFD}g", 'test css invalid codepoint decode');
# TODO test MySQL ANSI encode
# TODO test MySQL Standard Encode
# TODO test Oracle encode
# TODO test Unix encode
# TODO test Windows encode

is($html_codec->encode(immune => [], input => '<'), '&lt;', 'test HTML encode char');
is($html_codec->encode(immune => [], input => "\x{100}"), '&#x100;', 'test HTML encode 0x100');

is($percent_codec->encode(immune => [], input => '<'), '%3c', 'test percent encode <');
is($percent_codec->encode(immune => [], input => "\x{100}"), '%c4%80', 'test percent encode 0x100');

is($javascript_codec->encode(immune => [], input => '<'), '\\x3c', 'test javascript encode <');
is($javascript_codec->encode(immune => [], input => "\x{100}"), '\\u0100', 'test javascript encode 0x100');

is($vbscript_codec->encode(immune => [], input => '<'), 'chrw(60)', 'test vbscript encode <');
is($vbscript_codec->encode(immune => [], input => "\x{100}"), 'chrw(256)', 'test vbscript encode 0x100');

is($css_codec->encode(immune => [], input => '<'), '\\3c ', 'test CSS encode <');
is($css_codec->encode(immune => [], input => "\x{100}"), '\\100 ', 'test CSS encode 0x100');

# TODO various MySQL encoding tests...
# TODO various Oracle encoding tests...
# TODO various Unix encoding tests...

is($html_codec->decode(input => '&#116;&#101;&#115;&#116;!'), 'test!', 'test HTML decode decimal entities');
is($html_codec->decode(input => '&#x74;&#x65;&#x73;&#x74;!'), 'test!', 'test HTML decode hex entities');
is($html_codec->decode(input => '&jeff;'), '&jeff;', 'test HTML decode invalid attribute');

is($html_codec->decode(input => '&amp;'),       '&',         'test decode amp');
is($html_codec->decode(input => '&amp;X'),      '&X',        'test decode amp X');
is($html_codec->decode(input => '&amp'),        '&',         'test decode amp no semi');
is($html_codec->decode(input => '&ampX'),       '&X',        'test decode amp no semi X');
is($html_codec->decode(input => '&lt;'),        '<',         'test decode lt');
is($html_codec->decode(input => '&lt;X'),       '<X',        'test decode lt X');
is($html_codec->decode(input => '&lt'),         '<',         'test decode lt no semi');
is($html_codec->decode(input => '&ltX'),        '<X',        'test decode lt no semi X');
is($html_codec->decode(input => "&sup1;"),      "\x{00B9}",  'test decode sup1');
is($html_codec->decode(input => "&sup1;X"),     "\x{00B9}X", 'test decode sup1 X');
is($html_codec->decode(input => "&sup1"),       "\x{00B9}",  'test decode sup1 no semi');
is($html_codec->decode(input => "&sup1X"),      "\x{00B9}X", 'test decode sup1 no semi X');
is($html_codec->decode(input => "&sup2;"),      "\x{00B2}",  'test decode sup2');
is($html_codec->decode(input => "&sup2;X"),     "\x{00B2}X", 'test decode sup2 X');
is($html_codec->decode(input => "&sup2"),       "\x{00B2}",  'test decode sup2 no semi');
is($html_codec->decode(input => "&sup2X"),      "\x{00B2}X", 'test decode sup2 no semi X');
is($html_codec->decode(input => "&sup3;"),      "\x{00B3}",  'test decode sup3');
is($html_codec->decode(input => "&sup3;X"),     "\x{00B3}X", 'test decode sup3 X');
is($html_codec->decode(input => "&sup3"),       "\x{00B3}",  'test decode sup3 no semi');
is($html_codec->decode(input => "&sup3X"),      "\x{00B3}X", 'test decode sup3 no semi X');
is($html_codec->decode(input => "&sup;"),       "\x{2283}",  'test decode sup');
is($html_codec->decode(input => "&sup;X"),      "\x{2283}X", 'test decode sup X');
is($html_codec->decode(input => "&sup"),        "\x{2283}",  'test decode sup no semi');
is($html_codec->decode(input => "&supX"),       "\x{2283}X", 'test decode sup no semi X');
is($html_codec->decode(input => "&supe;"),      "\x{2287}",  'test decode supe'); 
is($html_codec->decode(input => "&supe;X"),     "\x{2287}X", 'test decode supe X');
is($html_codec->decode(input => "&supe"),       "\x{2287}",  'test decode supe no semi'); 
is($html_codec->decode(input => "&supeX"),      "\x{2287}X", 'test decode supe no semi X');
is($html_codec->decode(input => "&pi;"),        "\x{03C0}",  'test decode pi');
is($html_codec->decode(input => "&pi;X"),       "\x{03C0}X", 'test decode pi X');
is($html_codec->decode(input => "&pi"),         "\x{03C0}",  'test decode pi no semi');
is($html_codec->decode(input => "&piX"),        "\x{03C0}X", 'test decode pi no semi X');
is($html_codec->decode(input => "&piv;"),       "\x{03D6}",  'test decode piv');
is($html_codec->decode(input => "&piv;X"),      "\x{03D6}X", 'test decode piv X');
is($html_codec->decode(input => "&piv"),        "\x{03D6}",  'test decode piv no semi');
is($html_codec->decode(input => "&pivX"),       "\x{03D6}X", 'test decode piv no semi X');
is($html_codec->decode(input => "&theta;"),     "\x{03B8}",  'test decode theta');
is($html_codec->decode(input => "&theta;X"),    "\x{03B8}X", 'test decode theta X');
is($html_codec->decode(input => "&theta"),      "\x{03B8}",  'test decode theta no semi');
is($html_codec->decode(input => "&thetaX"),     "\x{03B8}X", 'test decode theta no semi X');
is($html_codec->decode(input => "&thetasym;"),  "\x{03D1}",  'test decode thetasym'); 
is($html_codec->decode(input => "&thetasym;X"), "\x{03D1}X", 'test decode thetasym X');
is($html_codec->decode(input => "&thetasym"),   "\x{03D1}",  'test decode thetasym no semi'); 
is($html_codec->decode(input => "&thetasymX"),  "\x{03D1}X", 'test decode thetasym no semi X');

is($percent_codec->decode(input => '%3c'), '<', 'test percent decode');
is($javascript_codec->decode(input => '\\x3c'), '<', 'test javascript decode backslash hex');
is($vbscript_codec->decode(input => '"<'), '<', 'test vbscript decode');
is($css_codec->decode(input => '\\<'), '<', 'test CSS decode');
is($css_codec->decode(input => '\\41xyz'), 'Axyz', 'test CSS decode hex no space');
is($css_codec->decode(input => '\\000041abc'), 'Aabc', 'test CSS decode zero hex no space');
is($css_codec->decode(input => '\\41 abc'), 'Aabc', 'test CSS decode hex space');
is($css_codec->decode(input => "abc\\\nxyz"), 'abcxyz', 'test CSS decode NL');
is($css_codec->decode(input => "abc\\\r\nxyz"), 'abcxyz', 'test CSS decode CRNL');

# TODO MySQL ANSI decode
# TODO MySQL standard decode
# TODO Oracle decode
# TODO Unix decode
# TODO Windows decode


