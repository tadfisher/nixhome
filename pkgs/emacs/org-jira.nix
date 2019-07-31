{ cl-lib ? null
, dash
, emacs
, fetchFromGitHub
, fetchurl
, lib
, melpaBuild
, org
, request
}:
melpaBuild {
  pname = "org-jira";
  ename = "org-jira";
  version = "20190712.443";
  src = fetchFromGitHub {
    owner = "ahungry";
    repo = "org-jira";
    rev = "d1d2ff6155c6259a066110ed13d1850143618f7b";
    sha256 = "064pxsf5kkv69bs1f6lhqsvqwxx19jwha3s6vj8rnk8smawv0w9r";
  };
  recipe = fetchurl {
    url = "https://raw.githubusercontent.com/milkypostman/melpa/e0a2fae6eecb6b4b36fe97ad99691e2c5456586f/recipes/org-jira";
    sha256 = "1sbypbz00ki222zpm47yplyprx7h2q076b3l07qfilk0sr8kf4ql";
    name = "recipe";
  };
  packageRequires = [ cl-lib dash emacs org request ];
  meta = {
    homepage = "https://melpa.org/#/org-jira";
    license = lib.licenses.free;
  };
}
