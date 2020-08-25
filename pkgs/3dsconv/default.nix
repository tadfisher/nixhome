{ lib, pythonPackages, fetchFromGitHub }:

with pythonPackages;

buildPythonApplication rec {
  pname = "3dsconv";
  version = "4.2dev";

  src = fetchFromGitHub {
    owner = "ihaveamac";
    repo = pname;
    rev = "bde8c8f1b70531b539e3cdb7595f6b21a0d43085";
    sha256 = "161jixaxlb4452wqz20pi2r1is7scb8ikx83mpzjw39hs0nfxkbr";
  };

  doCheck = false;

  buildInputs = [ pyaes ];

  meta = with lib; {
    description = "Python script to convert Nintendo 3DS CCI (\".cci\", \".3ds\") files to the CIA format";
    homepage = "https://github.com/ihaveamac/3dsconv";
    license = licenses.mit;
    maintainers = [ maintainers.tadfisher ];
  };
}
