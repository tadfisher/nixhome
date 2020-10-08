{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.emacs;

in

{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ditaa
      emacs-all-the-icons-fonts
      freefont_ttf
      graphviz
      (hunspellWithDicts [ hunspellDicts.en-us])
      jetbrains-mono
      jre
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      plantuml
      roboto
      roboto-mono
      silver-searcher
    ];

    programs.emacs.package = if (config.profiles.desktop.enable) then pkgs.emacs else pkgs.emacs-nox;

    programs.emacs.overrides = self: super: rec {
      seq = cfg.package;
      magit-delta = super.magit-delta.overrideAttrs (attrs: {
        nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ [ config.programs.git.package ];
      });
      treemacs = super.treemacs.overrideAttrs (attrs: {
        nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ [ pkgs.python3 ];
      });
    };

    programs.emacs.init = {
      enable = true;
      recommendedGcSettings = true;
      usePackageVerbose = false;

      prelude = ''
        ;; Disable startup message.
        (setq inhibit-startup-message t
              inhibit-startup-echo-area-message (user-login-name))

        (setq initial-major-mode 'fundamental-mode
              initial-scratch-message nil)

        ;; Disable some GUI distractions.
        (tool-bar-mode -1)
        (scroll-bar-mode -1)
        (menu-bar-mode -1)
        (blink-cursor-mode -1)

        (setq default-frame-alist
              '((vertical-scroll-bars . nil)
                (width . 100)))

        ;; Customize cursor.
        (setq-default cursor-type 'bar)

        ;; Set up fonts early.
        (set-face-attribute 'default
                            nil
                            :height 97
                            :family "JetBrains Mono"
                            :weight 'normal)
        (set-face-attribute 'variable-pitch
                            nil
                            :family "Roboto")

        ;; Set frame title.
        (setq frame-title-format
              '("" invocation-name ": "(:eval
                                        (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                          "%b"))))

        ;; Resize frames per-pixel.
        (setq frame-resize-pixelwise t)

        ;; Customize tab bar.
        (setq tab-bar-mode t)

        ;; Accept 'y' and 'n' rather than 'yes' and 'no'.
        (defalias 'yes-or-no-p 'y-or-n-p)

        ;; Don't want to move based on visual line.
        (setq line-move-visual nil)

        ;; Stop creating backup and autosave files.
        (setq make-backup-files nil
              auto-save-default nil)

        ;; Always show line and column number in the mode line.
        (line-number-mode)
        (column-number-mode)

        ;; Enable some features that are disabled by default.
        (put 'narrow-to-region 'disabled nil)

        ;; Typically, I only want spaces when pressing the TAB key. I also
        ;; want 4 of them.
        (setq-default indent-tabs-mode nil
                      tab-width 4
                      c-basic-offset 4)

        ;; Trailing white space are banned!
        (setq-default show-trailing-whitespace t)
        (add-hook 'before-save-hook 'delete-trailing-whitespace)

        ;; ...but sometimes we need to save a file with them.
        (defun save-buffer-preserve-whitespace (&optional arg)
          "Save the current buffer, preserving trailing whitespace."
          (interactive "p")
          (let ((before-save-hook (remove 'delete-trailing-whitespace before-save-hook)))
            (save-buffer arg)))

        ;; Make a reasonable attempt at using one space sentence separation.
        (setq sentence-end "[.?!][]\"')}]*\\($\\|[ \t]\\)[ \t\n]*"
              sentence-end-double-space nil)

        ;; I typically want to use UTF-8.
        (prefer-coding-system 'utf-8)

        ;; Nicer handling of regions.
        (transient-mark-mode 1)

        ;; Make moving cursor past bottom only scroll a single line rather
        ;; than half a page.
        (setq scroll-step 1
              scroll-conservatively 5)

        ;; Enable highlighting of current line.
        (global-hl-line-mode 1)

        ;; Set a reasonable default fill-column.
        (setq-default fill-column 100)

        ;; Improved handling of clipboard in GNU/Linux and otherwise.
        (setq select-enable-clipboard t
              select-enable-primary t
              save-interprogram-paste-before-kill t)

        ;; Pasting with middle click should insert at point, not where the
        ;; click happened.
        (setq mouse-yank-at-point t)

        ;; Enable a few useful commands that are initially disabled.
        (put 'upcase-region 'disabled nil)
        (put 'downcase-region 'disabled nil)

        (setq custom-file (locate-user-emacs-file "custom.el"))
        (when (file-exists-p custom-file)
              (load custom-file))

        ;; When finding file in non-existing directory, offer to create the
        ;; parent directory.
        (defun with-buffer-name-prompt-and-make-subdirs ()
          (let ((parent-directory (file-name-directory buffer-file-name)))
            (when (and (not (file-exists-p parent-directory))
                       (y-or-n-p (format "Directory `%s' does not exist! Create it? " parent-directory)))
              (make-directory parent-directory t))))

        (add-to-list 'find-file-not-found-functions #'with-buffer-name-prompt-and-make-subdirs)

        ;; Shouldn't highlight trailing spaces in terminal mode.
        (add-hook 'term-mode (lambda () (setq show-trailing-whitespace nil)))
        (add-hook 'term-mode-hook (lambda () (setq show-trailing-whitespace nil)))

        ;; Handle urls from the command line (also via emacsclient).
        (url-handler-mode 1)

        ;; Just use bash, don't ask.
        (setq explicit-shell-file-name "${pkgs.bashInteractive}/bin/bash")

        ;; Unbind M-SPC, which I use as a prefix key.
        (global-unset-key (kbd "M-SPC"))
      '';

      lsp = {
        enable = true;
        clients = {
          bash = {
            require = "lsp-bash";
            modes = [ "sh-mode" ];
            executables.bash-language-server = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
          };
          clangd = {
            require = "lsp-clients";
            modes = [ "c-mode" "c++mode" "objc-mode" ];
            config = ''
              (setq lsp-clients-clangd-executable "${pkgs.clang-tools}/bin/clangd")
            '';
          };
          clojure = {
            modes = [ "clojure-mode" "clojurec-mode" "clojurescript-mode" ];
            config = ''
              (setq lsp-clojure-server-command '("${pkgs.clojure-lsp}/bin/clojure-lsp"))
            '';
          };
          css = {
            modes = [ "css-mode" "less-css-mode" "sass-mode" "scss-mode" ];
            executables.css-languageserver = "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
          };
          # "dhall" = {
          #   modes = [ "dhall-mode" ];
          #   packages = [ pkgs.haskellPackages.dhall-lsp-server ];
          # };
          go = {
            modes = [ "go-mode" ];
            config = ''
              (setq lsp-gopls-server-path "${pkgs.gotools}/bin/gopls")
            '';
          };
          html = {
            modes = [ "html-mode" "sgml-mode" "mhtml-mode" "web-mode" ];
            executables.html-language-server = "${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver";
          };
          metals = {
            modes = [ "scala-mode" ];
            config = ''
              (setq lsp-metals-server-command '("${pkgs.metals}/bin/metals-emacs"))
            '';
          };
          rust = {
            modes = [ "rust-mode" ];
            config = ''
              (setq lsp-rust-analyzer-server-command '("${pkgs.rust-analyzer}/bin/rust-analyzer"))
              (setf (lsp--client-environment-fn (gethash 'rust-analyzer lsp-clients))
                    (lambda () `(("PATH" . ,(concat "${pkgs.cargo}/bin:${pkgs.rustfmt}/bin:" (getenv "PATH"))))))
            '';
          };
        };
        init = ''
          (setq lsp-eldoc-render-all nil
                lsp-keymap-prefix "M-SPC l"
                lsp-prefer-capf t)
        '';
      };

      usePackage = {
        abbrev = {
          enable = true;
          diminish = [ "abbrev-mode" ];
          command = [ "abbrev-mode" ];
        };

        adoc-mode = {
          enable = true;
          mode = [
            ''"\\.txt\\'"''
            ''"\\.adoc\\'"''
          ];
        };

        ansi-color = {
          enable = true;
          command = [ "ansi-color-apply-on-region" ];
        };

        autorevert = {
          enable = true;
          diminish = [ "auto-revert-mode" ];
          command = [ "auto-revert-mode" ];
        };

        all-the-icons = {
          enable = true;
          defer = true;
          config = ''
            (dolist
                (entry '((forge-issue-list-mode       all-the-icons-alltheicon "git"                :face all-the-icons-lred)
                         (forge-notifications-mode    all-the-icons-alltheicon "git"                :face all-the-icons-lred)
                         (forge-post-mode             all-the-icons-alltheicon "git"                :face all-the-icons-lred)
                         (forge-pullreq-list-mode     all-the-icons-alltheicon "git"                :face all-the-icons-lred)
                         (forge-repository-list-mode  all-the-icons-alltheicon "git"                :face all-the-icons-lred)
                         (forge-topic-list-mode       all-the-icons-alltheicon "git"                :face all-the-icons-lred)
                         (forge-topic-mode            all-the-icons-alltheicon "git"                :face all-the-icons-lred)
                         (notmuch-hello-mode          all-the-icons-material   "mail" :v-adjust 0.0 :face all-the-icons-red)
                         (notmuch-message-mode        all-the-icons-material   "mail" :v-adjust 0.0 :face all-the-icons-red)
                         (notmuch-search-mode         all-the-icons-material   "mail" :v-adjust 0.0 :face all-the-icons-red)
                         (notmuch-show-mode           all-the-icons-material   "mail" :v-adjust 0.0 :face all-the-icons-red)
                         (notmuch-tree-mode           all-the-icons-material   "mail" :v-adjust 0.0 :face all-the-icons-red)))
              (add-to-list 'all-the-icons-mode-icon-alist entry))
          '';
        };

        display-fill-column-indicator = {
          enable = true;
          package = epkg: cfg.package;
          hook = [ ''
            (display-fill-column-indicator . (lambda ()
                                               (when display-fill-column-indicator-mode
                                                 (setq display-fill-column-indicator
                                                       (not (or buffer-read-only
                                                       (derived-mode-p 'comint-mode)))))))
          '' ];
          config = ''
            (global-display-fill-column-indicator-mode)
          '';
        };

        pretty-tabs = {
          enable = true;
          after = [ "tab-bar" "all-the-icons" ];
          package = epkgs: (pkgs.emacsPackagesCustom epkgs).pretty-tabs;
          extraConfig = ''
            :functions pretty-tabs-mode
          '';
          config = ''
            (if (daemonp)
                (progn
                  (require 'server)
                  (add-hook 'server-after-make-frame-hook
                            'pretty-tabs-mode))
              (pretty-tabs-mode))
          '';
        };

        tab-bar = {
          enable = true;
          after = [ "all-the-icons" ];
          extraConfig = ''
            :functions all-the-icons-material
          '';
          config = ''
            (setq tab-bar-close-button
                  (propertize (all-the-icons-material "close" :face 'tab-bar-tab)
                              'close-tab t
                              :help "Close tab")
                  tab-bar-new-button
                  (all-the-icons-material "add" :face 'tab-bar))
          '';
        };

        base16-theme = {
          enable = true;
        };

        base16-plata-noir-theme = {
          enable = true;
          package = epkgs: (pkgs.emacsPackagesCustom epkgs).base16-plata-theme;
          after = [ "base16-theme" "pretty-tabs" ];
          config = ''
            (when-let* ((dir (file-name-directory
                              (locate-file "base16-plata-noir-theme"
                                           load-path
                                           (get-load-suffixes)))))
              (add-to-list 'custom-theme-load-path dir)
              (if (daemonp)
                  (progn
                    (require 'server)
                    (add-hook 'server-after-make-frame-hook
                              (lambda ()
                                (if (member 'base16-plata-noir custom-known-themes)
                                    (enable-theme 'base16-plata-noir)
                                  (load-theme 'base16-plata-noir t)))))
                (load-theme 'base16-plata-noir t)))
          '';
        };

        # From https://github.com/mlb-/emacs.d/blob/a818e80f7790dffa4f6a775987c88691c4113d11/init.el#L472-L482
        compile = {
          enable = true;
          defer = true;
          after = [ "ansi-color" ];
          hook = [
            ''
              (compilation-filter . (lambda ()
                                      (when (eq major-mode 'compilation-mode)
                                        (ansi-color-apply-on-region compilation-filter-start (point-max)))))
            ''
          ];
        };

        cc-mode = {
          enable = true;
          defer = true;
          hook = [
            ''
              (c-mode-common . (lambda ()
                                 (subword-mode)

                                 (c-set-offset 'arglist-intro '++)))
            ''
          ];
        };

        coffee-mode = {
          enable = true;
          mode = [ ''"\\.coffee\\'"'' ];
        };

        dhall-mode = {
          enable = true;
          mode = [ ''"\\.dhall\\'"'' ];
        };

        dockerfile-mode = {
          enable = true;
          mode = [ ''"Dockerfile\\'"'' ];
        };

        doom-modeline = {
          enable = true;
          extraConfig = ''
            :functions doom-modeline-mode
          '';
          config = ''
            (setq doom-modeline-buffer-file-name-style 'truncate-except-project)
            (if (daemonp)
                (add-hook 'server-after-make-frame-hook
                          (lambda ()
                            (doom-modeline-mode)
                            (custom-reevaluate-setting 'doom-modeline-icon)))
              (doom-modeline-mode))
          '';
        };

        drag-stuff = {
          enable = true;
          bind = {
            "M-<up>" = "drag-stuff-up";
            "M-<down>" = "drag-stuff-down";
          };
        };

        ediff = {
          enable = true;
          defer = true;
          config = ''
            (setq ediff-window-setup-function 'ediff-setup-windows-plain)
          '';
        };

        eldoc = {
          enable = true;
          diminish = [ "eldoc-mode" ];
          command = [ "eldoc-mode" ];
        };

        # Enable Electric Indent mode to do automatic indentation on RET.
        electric = {
          enable = true;
          command = [ "electric-indent-local-mode" ];
          hook = [
            "(prog-mode . electric-indent-mode)"
          ];
        };

        etags = {
          enable = true;
          defer = true;
          # Avoid spamming reload requests of TAGS files.
          config = "(setq tags-revert-without-query t)";
        };

        ggtags = {
          enable = true;
          diminish = [ "ggtags-mode" ];
          command = [ "ggtags-mode" ];
          hook = [
            ''
              (c-mode-common-hook
               . (lambda ()
                   (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
                     (ggtags-mode 1))))
            ''
          ];
        };

        groovy-mode = {
          enable = true;
          mode = [
            ''"\\.gradle\\'"''
            ''"\\.groovy\\'"''
            ''"Jenkinsfile\\'"''
          ];
        };

        ispell = {
          enable = true;
          defer = 1;
        };

        js = {
          enable = true;
          mode = [
            ''("\\.js\\'" . js-mode)''
            ''("\\.json\\'" . js-mode)''
          ];
          config = ''
            (setq js-indent-level 2)
          '';
        };

        ligature = {
          enable = true;
          package = epkgs: (pkgs.emacsPackagesCustom epkgs).ligature;
          config = ''
            (ligature-set-ligatures 'prog-mode '("-->" "//" "/**" "/*" "*/" "<!--" ":=" "->>" "<<-"
                                                 "->" "<-" "<=>" "==" "!=" "<=" ">=" "=:=" "!=="
                                                 "&&" "&&&" "||" "..." ".." "///" "===" "++" "--"
                                                 "=>" "|>" "<|" "||>" "<||" "|||>" "<|||::=" "|]"
                                                 "[|" "|}" "{|" "[<" ">]" ":?>" ":?" "/=" "[||]"
                                                 "!!" "?:" "?." "::" "+++" "??" "##" "###" "####"
                                                 ":::" ".?" "?=" "=!=" "<|>" "<:" ":<" ":>" ">:"
                                                 "<>" "***" ";;" "/==" ".=" ".-" "__" "=/=" "<-<"
                                                 "<<<" ">>>" "<=<" "<<=" "<==" "<==>" "==>" "=>>"
                                                 ">=>" ">>=" ">>-" ">-" "<~>" "-<" "-<<" "<<" "---"
                                                 "<-|" "<=|" "\\" "\\/" "|=>" "|->" "<~~" "<~" "~~"
                                                 "~~>" "~>" "<$>" "<$" "$>" "<+>" "<+" "+>" "<*>"
                                                 "<*" "*>" "</" "</>" "/>" "<->" "..<" "~=" "~-"
                                                 "-~" "~@" "^=" "-|" "_|_" "|-" "||-" "|=" "||="
                                                 "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#="))
            (global-ligature-mode t)
          '';
        };

        scala-mode = {
          enable = true;
        };

        sass-mode.enable = true;

        flyspell = {
          enable = true;
          diminish = [ "flyspell-mode" ];
          command = [ "flyspell-mode" "flyspell-prog-mode" ];
          hook = [
            # Spell check in text and programming mode.
            "(text-mode . flyspell-mode)"
            "(prog-mode . flyspell-prog-mode)"
          ];
          config = ''
            ;; In flyspell I typically do not want meta-tab expansion
            ;; since it often conflicts with the major mode. Also,
            ;; make it a bit less verbose.
            (setq flyspell-issue-message-flag nil
                  flyspell-issue-welcome-flag nil
                  flyspell-use-meta-tab nil)
          '';
        };

        # Remember where we where in a previously visited file. Built-in.
        saveplace = {
          enable = true;
          config = ''
            (setq-default save-place t)
            (setq save-place-file (locate-user-emacs-file "places"))
          '';
        };

        # More helpful buffer names. Built-in.
        uniquify = {
          enable = true;
          config = ''
            (setq uniquify-buffer-name-style 'post-forward)
          '';
        };

        # Hook up hippie expand.
        hippie-exp = {
          enable = true;
          bind = {
            "M-?" = "hippie-expand";
          };
        };

        which-key = {
          enable = true;
          command = [ "which-key-mode" ];
          diminish = [ "which-key-mode" ];
          defer = 2;
          config =
            let
              descriptions = {
                "M-SPC p" = "project";
              };
              replacements = optionalString (descriptions != {}) ''
                (which-key-add-key-based-replacements
                  ${concatStringsSep "\n  " (mapAttrsToList (k: d: ''"${k}" "${d}"'') descriptions)})
              '';

            in ''
              ${replacements}

              (which-key-mode)
            '';
        };

        # Enable winner mode. This global minor mode allows you to
        # undo/redo changes to the window configuration. Uses the
        # commands C-c <left> and C-c <right>.
        winner = {
          enable = true;
          config = "(winner-mode 1)";
        };

        writeroom-mode = {
          enable = true;
          command = [ "writeroom-mode" ];
          bind = {
            "M-[" = "writeroom-decrease-width";
            "M-]" = "writeroom-increase-width";
          };
          hook = [ "(writeroom-mode . visual-line-mode)" ];
        };

        buffer-move = {
          enable = true;
          bind = {
            "C-S-<up>"    = "buf-move-up";
            "C-S-<down>"  = "buf-move-down";
            "C-S-<left>"  = "buf-move-left";
            "C-S-<right>" = "buf-move-right";
          };
        };

        ivy = {
          enable = true;
          demand = true;
          diminish = [ "ivy-mode" ];
          command = [ "ivy-mode" ];
          config = ''
            (setq ivy-use-virtual-buffers t
                  ivy-count-format "%d/%d "
                  ivy-virtual-abbreviate 'full
                  ivy-initial-inputs-alist '((counsel-package . "^+ ")
                                             (org-refile . "^")
                                             (org-agenda-refile . "^")
                                             (org-capture-refile . "^")
                                             (counsel-describe-function . "^")
                                             (counsel-describe-variable . "^")
                                             (counsel-org-capture . "^")
                                             (Man-completion-table . "^")
                                             (woman . "^")))

            (ivy-mode 1)
          '';
        };

        ivy-hydra = {
          enable = true;
        };

        ivy-prescient = {
          enable = false;
          after = [ "ivy" ];
          config = ''
            (ivy-prescient-mode 1)
          '';
        };

        ivy-xref = {
          enable = true;
          after = [ "ivy" "xref" ];
          command = [ "ivy-xref-show-xrefs" ];
          config = ''
            (setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
          '';
        };

        swiper = {
          enable = true;
          command = [ "swiper" "swiper-all" "swiper-isearch" ];
          bind = {
            "C-s" = "swiper-isearch";
          };
        };

        # Lets counsel do prioritization. A fork of smex.
        amx = {
          enable = true;
          command = [ "amx-initialize" ];
        };

        counsel = {
          enable = true;
          bind = {
            "C-x C-f" = "counsel-find-file";
            "C-x C-r" = "counsel-recentf";
            "C-x C-y" = "counsel-yank-pop";
            "M-x" = "counsel-M-x";
          };
          diminish = [ "counsel-mode" ];
        };

        counsel-projectile = {
          enable = true;
          demand = true;
          after = [ "projectile" ];
          config = ''
            (counsel-projectile-mode 1)
          '';
        };

        nyan-mode = {
          enable = true;
          command = [ "nyan-mode" ];
          config = ''
            (setq nyan-wavy-trail t)
          '';
        };

        string-inflection = {
          enable = true;
          bind = {
            "C-c C-u" = "string-inflection-all-cycle";
          };
        };

        # Configure magit, a nice mode for the git SCM.
        magit = {
          enable = true;
          config = ''
            (setq magit-completing-read-function 'ivy-completing-read
                  magit-git-executable "${config.programs.git.package}/bin/git")
            (add-to-list 'git-commit-style-convention-checks
                         'overlong-summary-line)
          '';
        };

        magit-delta = {
          enable = true;
          after = [ "magit" ];
          config = ''
            (setq magit-delta-delta-executable "${pkgs.gitAndTools.delta}/bin/delta")
            (magit-delta-mode)
          '';
        };

        forge = {
          enable = true;
          after = [ "magit" ];
        };

        git-messenger = {
          enable = true;
          bind = {
            "C-x v p" = "git-messenger:popup-message";
          };
        };

        multiple-cursors = {
          enable = true;
          bind = {
            "C-S-c C-S-c" = "mc/edit-lines";
            "C-c m" = "mc/mark-all-like-this";
            "C->" = "mc/mark-next-like-this";
            "C-<" = "mc/mark-previous-like-this";
          };
        };

        avy = {
          enable = true;
          extraConfig = ''
            :bind* ("C-c SPC" . avy-goto-word-or-subword-1)
          '';
        };

        undo-tree = {
          enable = true;
          demand = true;
          diminish = [ "undo-tree-mode" ];
          command = [ "global-undo-tree-mode" ];
          config = ''
            (setq undo-tree-visualizer-relative-timestamps t
                  undo-tree-visualizer-timestamps t)
            (global-undo-tree-mode)
          '';
        };

        # Configure AUCTeX.
        latex = {
          enable = true;
          package = epkgs: epkgs.auctex;
          mode = [ ''("\\.tex\\'" . latex-mode)'' ];
          hook = [
            ''
              (LaTeX-mode
               . (lambda ()
                   (turn-on-reftex)       ; Hook up AUCTeX with RefTeX.
                   (auto-fill-mode)
                   (define-key LaTeX-mode-map [adiaeresis] "\\\"a")))
            ''
          ];
          config = ''
            (setq TeX-PDF-mode t
                  TeX-auto-save t
                  TeX-parse-self t
                  TeX-output-view-style '(("^pdf$" "." "evince %o")
                                          ( "^ps$" "." "evince %o")
                                          ("^dvi$" "." "evince %o")))

            ;; Add Glossaries command. See
            ;; http://tex.stackexchange.com/a/36914
            (eval-after-load "tex"
              '(add-to-list
                'TeX-command-list
                '("Glossaries"
                  "makeglossaries %s"
                  TeX-run-command
                  nil
                  t
                  :help "Create glossaries file")))
          '';
        };

        direnv = {
          enable = true;
          demand = true;
          hook = [
            ''(lsp-before-initialize . direnv-update-environment)''
          ];
          config = ''
            (setq direnv-always-show-summary nil)
            (direnv-mode 1)
          '';
        };

        mpdel = {
          enable = true;
          diminish = [ "mpdel-mode" ];
          init = ''
            (setq mpdel-prefix-key (kbd "C-c z"))
          '';
          config = ''
            (mpdel-mode 1)
          '';
        };

        ivy-mpdel = {
          enable = true;
          demand = true;
          after = [ "mpdel" ];
        };

        lsp-ui = {
          enable = true;
          command = [ "lsp-ui-mode" ];
        };

        lsp-ivy = {
          enable = true;
          command = [ "lsp-ivy-workspace-symbol" ];
        };

        lsp-treemacs = {
          enable = true;
          command = [ "lsp-treemacs-errors-list" ];
        };

        dap-mode = {
          enable = true;
          after = [ "lsp-mode" ];
          command = [ "dap-mode" "dap-ui-mode" ];
          config = ''
            (dap-mode t)
            (dap-ui-mode t)
          '';
        };

        #  Setup RefTeX.
        reftex = {
          enable = true;
          defer = true;
          config = ''
            (setq reftex-default-bibliography '("~/research/bibliographies/main.bib")
                  reftex-cite-format 'natbib
                  reftex-plug-into-AUCTeX t)
          '';
        };

        haskell-mode = {
          enable = true;
          command = [
            "haskell-decl-scan-mode"
            "haskell-doc-mode"
            "haskell-indentation-mode"
            "interactive-haskell-mode"
          ];
          mode = [
            ''("\\.hs\\'" . haskell-mode)''
            ''("\\.hsc\\'" . haskell-mode)''
            ''("\\.c2hs\\'" . haskell-mode)''
            ''("\\.cpphs\\'" . haskell-mode)''
            ''("\\.lhs\\'" . haskell-literate-mode)''
          ];
          hook = [
            ''
              (haskell-mode
               . (lambda ()
                   (subword-mode +1)
                   (interactive-haskell-mode +1)
                   (haskell-doc-mode +1)
                   (haskell-indentation-mode +1)
                   (haskell-decl-scan-mode +1)))
            ''
          ];
          bindLocal = {
            haskell-mode-map = {
              "C-c h i" = "haskell-navigate-imports";
              "C-c r o" = "haskell-mode-format-imports";
              "C-<right>" = "haskell-move-nested-right";
              "C-<left>" = "haskell-move-nested-left";
            };
          };
          config = ''
            (require 'haskell)
            (require 'haskell-doc)

            (setq haskell-process-auto-import-loaded-modules t
                  haskell-process-suggest-remove-import-lines t
                  haskell-process-log t
                  haskell-notify-p t)

            (setq haskell-process-args-cabal-repl
                  '("--ghc-options=+RTS -M500m -RTS -ferror-spans -fshow-loaded-modules"))
          '';
        };

        haskell-cabal = {
          enable = true;
          mode = [ ''("\\.cabal\\'" . haskell-cabal-mode)'' ];
          bindLocal = {
            haskell-cabal-mode-map = {
              "C-c C-c" = "haskell-process-cabal-build";
              "C-c c" = "haskell-process-cabal";
              "C-c C-b" = "haskell-interactive-bring";
            };
          };
        };

        markdown-mode = {
          enable = true;
          mode = [
            ''"\\.mdwn\\'"''
            ''"\\.markdown\\'"''
            ''"\\.md\\'"''
          ];
        };

        pandoc-mode = {
          enable = true;
          after = [ "markdown-mode" ];
          hook = [ "markdown-mode" ];
          bindLocal = {
            markdown-mode-map = {
              "C-c C-c" = "pandoc-run-pandoc";
            };
          };
          config = ''
            (setq pandoc-binary "${pkgs.pandoc}/bin/pandoc")
          '';
        };

        meson-mode = {
          enable = true;
	  mode = [ ''"/meson\\(\\.build\\|_options\\.txt\\)\\'"'' ];
        };

        nix-mode = {
          enable = true;
          mode = [ ''"\\.nix\\'"'' ''"\\.nix.in\\'"'' ];
        };

        nix-buffer = {
          enable = true;
          init = ''
            (defvar eshell-path-env "");
          '';
        };

        nix-build = {
          enable = true;
          command = [ "nix-build" ];
        };

        nix-drv-mode = {
          enable = true;
          mode = [ ''"\\.drv\\'"'' ];
        };

        nix-repl = {
          enable = true;
        };

        nix-shell = {
          enable = true;
        };

        # Use ripgrep for fast text search in projects. I usually use
        # this through Projectile.
        ripgrep = {
          enable = true;
          command = [ "ripgrep-regexp" ];
          config = ''
            (setq ripgrep-executable "${pkgs.ripgrep}/bin/rg")
          '';
        };

        org = {
          enable = true;
          bind = {
            "M-SPC o c" = "org-capture";
            "M-SPC o a" = "org-agenda";
            "M-SPC o l" = "org-store-link";
            "M-SPC o b" = "org-switchb";
          };
          bindKeyMap = {
            "M-SPC M-SPC" = "org-mode-map";
          };
          hook = [
            ''
              (org-mode
               . (lambda ()
                   (add-hook 'completion-at-point-functions
                             'pcomplete-completions-at-point nil t)))
            ''
          ];
          config = ''
            ;; Some general stuff.
            (setq org-reverse-note-order t
                  org-use-fast-todo-selection t)

            ;; (setq org-tag-alist rah-org-tag-alist)

            ;; GTD
            (defun tad/org-archive-done ()
              "Archive all DONE tasks."
              (interactive)
              (org-map-entries 'org-archive-subtree "/DONE" 'file))

            (require 'find-lisp)

            (setq org-directory "${config.home.homeDirectory}/doc/org"
                  tad/org-inbox (expand-file-name "inbox.org" org-directory)
                  tad/org-email (expand-file-name "email.org" org-directory)
                  org-capture-templates
                  `(("i" "inbox" entry (file ,tad/org-inbox)
                     "* TODO %?")
                    ("e" "email" entry (file+headline ,tad/org-email "Emails")
                     "* TODO [#A] Reply: %a" :immediate-finish t)
                    ("l" "link" entry (file ,tad/org-inbox)
                     "* TODO %(org-cliplink-capture)" :immediate-finish t)
                    ("c" "org-protocol-capture" entry (file ,tad/org-inbox)
                     "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t))
                  org-todo-keywords
                  '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                    (sequence "WAITING(w@/!)" "HOLD(h@/!)" "CANCELED(c@/!)"))
                  org-log-done 'time
                  org-log-into-drawer t
                  org-log-state-notes-insert-after-drawers nil
                  org-refile-targets '((org-agenda-files :level . 1))
                  org-refile-use-outline-path t
                  org-outline-path-complete-in-steps nil
                  org-refile-allow-creating-parent-nodes 'confirm)

            ;; Active Org-babel languages
            (org-babel-do-load-languages 'org-babel-load-languages
                                         '((plantuml . t)
                                           (http . t)
                                           (shell . t)))

            ;; Unfortunately org-mode tends to take over keybindings that
            ;; start with C-c.
            (unbind-key "C-c SPC" org-mode-map)
            (unbind-key "C-c w" org-mode-map)
          '';
        };

        org-agenda = {
          enable = true;
          after = [ "org" "transient" ];
          defer = true;
          config = ''
            (setq org-agenda-files `(,org-directory)
                  org-agenda-span 5
                  org-deadline-warning-days 14
                  org-agenda-show-all-dates t
                  org-agenda-skip-deadline-if-done t
                  org-agenda-skip-scheduled-if-done t
                  org-agenda-start-on-weekday t)
          '';
        };

        org-protocol = {
          enable = true;
          demand = true;
        };

        # org-mobile = {
        #   enable = true;
        #   after = [ "org" ];
        #   defer = true;
        # };

        ob-http = {
          enable = true;
          after = [ "org" ];
          defer = true;
        };

        ob-plantuml = {
          enable = true;
          after = [ "org" ];
          defer = true;
          config = ''
            (setq org-plantuml-jar-path "${pkgs.plantuml}/lib/plantuml.jar")
          '';
        };

        org-ql = {
          enable = true;
        };

        org-table = {
          enable = true;
          after = [ "org" ];
          command = [ "orgtbl-to-generic" ];
          hook = [
            # For orgtbl mode, add a radio table translator function for
            # taking a table to a psql internal variable.
            ''
              (orgtbl-mode
               . (lambda ()
                   (defun rah-orgtbl-to-psqlvar (table params)
                     "Converts an org table to an SQL list inside a psql internal variable"
                     (let* ((params2
                             (list
                              :tstart (concat "\\set " (plist-get params :var-name) " '(")
                              :tend ")'"
                              :lstart "("
                              :lend "),"
                              :sep ","
                              :hline ""))
                            (res (orgtbl-to-generic table (org-combine-plists params2 params))))
                       (replace-regexp-in-string ",)'$"
                                                 ")'"
                                                 (replace-regexp-in-string "\n" "" res))))))
            ''
          ];
          config = ''
            (unbind-key "C-c SPC" orgtbl-mode-map)
            (unbind-key "C-c w" orgtbl-mode-map)
          '';
          extraConfig = ''
            :functions org-combine-plists
          '';
        };

        org-capture = {
          enable = true;
          after = [ "org" ];
          config = ''
            ;; (setq org-capture-templates rah-org-capture-templates)
          '';
        };

        org-clock = {
          enable = true;
          after = [ "org" ];
          config = ''
            (setq org-clock-rounding-minutes 5
                  org-clock-out-remove-zero-time-clocks t)
          '';
        };

        org-duration = {
          enable = true;
          after = [ "org" ];
          config = ''
            ;; I always want clock tables and such to be in hours, not days.
            (setq org-duration-format (quote h:mm))
          '';
        };

        org-bullets = {
          enable = true;
          hook = [ "(org-mode . org-bullets-mode)" ];
        };

        org-tree-slide = {
          enable = true;
          command = [ "org-tree-slide-mode" ];
        };

        ox-moderncv = {
          enable = true;
          package = epkgs: (pkgs.emacsPackagesCustom epkgs).org-cv;
          after = [ "ox-publish" ];
          config = ''
            (defun org-moderncv-export-to-pdf
                (&optional async subtreep visible-only body-only ext-plist)
              "Export current buffer as a moderncv CV (PDF)."
              (interactive)
              (let ((file (org-export-output-file-name ".tex" subtreep)))
                (org-export-to-file 'moderncv file
                  async subtreep visible-only body-only ext-plist
                  (lambda (file) (org-latex-compile file)))))

            (let ((backend (org-export-get-backend 'moderncv)))
              (setf (org-export-backend-menu backend)
                    '(?l 1
                         ((?C "As PDF file (moderncv)" org-moderncv-export-to-pdf)))))
          '';
        };

        # Set up yasnippet. Defer it for a while since I don't generally
        # need it immediately.
        yasnippet = {
          enable = true;
          defer = 1;
          diminish = [ "yas-minor-mode" ];
          command = [ "yas-global-mode" "yas-minor-mode" ];
          hook = [
            # Yasnippet interferes with tab completion in ansi-term.
            "(term-mode . (lambda () (yas-minor-mode -1)))"
          ];
          config = "(yas-global-mode 1)";
        };

        # Doesn't seem to work, complains about # in go snippets.
        yasnippet-snippets = {
          enable = false;
          after = [ "yasnippet" ];
        };

        # Setup the cperl-mode, which I prefer over the default Perl
        # mode.
        cperl-mode = {
          enable = true;
          defer = true;
          hook = [ "ggtags-mode" ];
          command = [ "cperl-set-style" ];
          config = ''
            (setq ggtags-executable-directory "${pkgs.global}/bin")

            ;; Avoid deep indentation when putting function across several
            ;; lines.
            (setq cperl-indent-parens-as-block t)

            ;; Use cperl-mode instead of the default perl-mode
            (defalias 'perl-mode 'cperl-mode)
            (cperl-set-style "PerlStyle")
          '';
        };

        # Setup ebib, my chosen bibliography manager.
        ebib = {
          enable = true;
          command = [ "ebib" ];
          hook = [
            # Highlighting of trailing whitespace is a bit annoying in ebib.
            ''
              (ebib-index-mode-hook
               . (lambda ()
                   (setq show-trailing-whitespace nil)))
            ''

            ''
              (ebib-entry-mode-hook
               . (lambda ()
                   (setq show-trailing-whitespace nil)))
            ''
          ];
          config = ''
            (setq ebib-latex-preamble '("\\usepackage{a4}"
                                        "\\bibliographystyle{amsplain}")
                  ebib-print-preamble '("\\usepackage{a4}")
                  ebib-print-tempfile "/tmp/ebib.tex"
                  ebib-extra-fields '(crossref
                                      url
                                      annote
                                      abstract
                                      keywords
                                      file
                                      timestamp
                                      doi))
          '';
        };

        smartparens = {
          enable = true;
          defer = 1;
          diminish = [ "smartparens-mode" ];
          command = [ "smartparens-global-mode" "show-smartparens-global-mode" ];
          bindLocal = {
            smartparens-mode-map = {
              "C-M-f" = "sp-forward-sexp";
              "C-M-b" = "sp-backward-sexp";
            };
          };
          config = ''
            (require 'smartparens-config)
            (smartparens-global-mode t)
            (show-smartparens-global-mode t)
          '';
        };

        flycheck = {
          enable = true;
          diminish = [ "flycheck-mode" ];
          command = [ "global-flycheck-mode" ];
          defer = 1;
          config = ''
            ;; Only check buffer when mode is enabled or buffer is saved.
            (setq flycheck-check-syntax-automatically '(mode-enabled save))

            ;; Enable flycheck in all eligible buffers.
            (global-flycheck-mode)
          '';
        };

        flycheck-haskell = {
          enable = true;
          hook = [ "(flycheck-mode . flycheck-haskell-setup)" ];
        };

        flycheck-plantuml = {
          enable = true;
          hook = [ "(flycheck-mode . flycheck-plantuml-setup)" ];
        };

        projectile = {
          enable = true;
          diminish = [ "projectile-mode" ];
          command = [ "projectile-mode" ];
          bindKeyMap = {
            "M-SPC p" = "projectile-command-map";
          };
          config = ''
            (setq projectile-enable-caching t
                  projectile-completion-system 'ivy)
            (projectile-mode 1)
          '';
        };

        plantuml-mode = {
          enable = true;
          mode = [ ''"\\.puml\\'"'' ];
          config = ''
            (setq plantuml-jar-path "${pkgs.plantuml}/lib/plantuml.jar")
          '';
        };

        ace-window = {
          enable = true;
          extraConfig = ''
            :bind* (("C-c w" . ace-window))
          '';
        };

        company = {
          enable = true;
          diminish = [ "company-mode" ];
          hook = [ "(after-init . global-company-mode)" ];
          extraConfig = ''
            :bind (:map company-mode-map
                        ([remap completion-at-point] . company-complete-common)
                        ([remap complete-symbol] . company-complete-common))
          '';
          config = ''
            (setq company-minimum-prefix-length 1
                  company-idle-delay 0.0
                  company-show-numbers t)
          '';
        };

        company-yasnippet = {
          enable = true;
          bind = {
            "M-/" = "company-yasnippet";
          };
        };

        company-dabbrev = {
          enable = true;
          after = [ "company" ];
          command = [ "company-dabbrev" ];
          config = ''
            (setq company-dabbrev-downcase nil
                  company-dabbrev-ignore-case t)
          '';
        };

        company-quickhelp = {
          enable = true;
          after = [ "company" ];
          command = [ "company-quickhelp-mode" ];
          config = ''
            (company-quickhelp-mode 1)
          '';
        };

        company-cabal = {
          enable = true;
          after = [ "company" ];
          command = [ "company-cabal" ];
          config = ''
            (add-to-list 'company-backends 'company-cabal)
          '';
        };

        company-restclient = {
          enable = true;
          after = [ "company" "restclient" ];
          command = [ "company-restclient" ];
          config = ''
            (add-to-list 'company-backends 'company-restclient)
          '';
        };

        json-mode = {
          enable = true;
        };

        php-mode = {
          enable = true;
          mode = [ ''"\\.php\\'"'' ];
          hook = [ "ggtags-mode" ];
        };

        protobuf-mode = {
          enable = true;
          mode = [ ''"'\\.proto\\'"'' ];
        };

        python = {
          enable = true;
          mode = [ ''("\\.py\\'" . python-mode)'' ];
          hook = [ "ggtags-mode" ];
        };

        restclient = {
          enable = true;
          mode = [ ''("\\.http\\'" . restclient-mode)'' ];
        };

        transpose-frame = {
          enable = true;
          bind = {
            "C-c f t" = "transpose-frame";
          };
        };

        tt-mode = {
          enable = true;
          mode = [ ''"\\.tt\\'"'' ];
        };

        smart-tabs-mode = {
          enable = false;
          config = ''
            (smart-tabs-insinuate 'c 'c++ 'cperl 'java)
          '';
        };

        octave = {
          enable = true;
          mode = [
            ''("\\.m\\'" . octave-mode)''
          ];
        };

        yaml-mode = {
          enable = true;
          mode = [ ''"\\.yaml\\'"'' ];
        };

        wc-mode = {
          enable = true;
          command = [ "wc-mode" ];
        };

        # web-mode = {
        #   enable = true;
        #   mode = [
        #     ''"\\.html\\'"''
        #     ''"\\.jsx?\\'"''
        #   ];
        #   config = ''
        #     (setq web-mode-attr-indent-offset 4
        #           web-mode-code-indent-offset 2
        #           web-mode-markup-indent-offset 2)

        #     (add-to-list 'web-mode-content-types '("jsx" . "\\.jsx?\\'"))
        #   '';
        # };

        dired = {
          enable = true;
          defer = true;
          hook = [''(dired-mode . dired-hide-details-mode)''];
          init = ''
            (setq dired-listing-switches "-al --group-directories-first")
          '';
          config = ''
            (put 'dired-find-alternate-file 'disabled nil)
            (setq dired-target-dwim t)
            ;; Use the system trash can.
            (setq delete-by-moving-to-trash t)
          '';
        };

        wdired = {
          enable = true;
          bindLocal = {
            dired-mode-map = {
              "C-c C-w" = "wdired-change-to-wdired-mode";
            };
          };
          config = ''
            ;; I use wdired quite often and this setting allows editing file
            ;; permissions as well.
            (setq wdired-allow-to-change-permissions t)
          '';
        };

        dired-x = {
          enable = true;
          hook = [''(dired-mode . dired-omit-mode)''];
        };

        dired-hide-dotfiles = {
          enable = true;
          hook = [''(dired-mode . dired-hide-dotfiles-mode)''];
          bindLocal = {
            dired-mode-map = {
              "C-c C-." = "dired-hide-dotfiles-mode";
            };
          };
        };

        all-the-icons-dired = {
          enable = true;
          hook = [''(dired-mode . all-the-icons-dired-mode)''];
        };

        recentf = {
          enable = true;
          command = [ "recentf-mode" ];
          config = ''
            (setq recentf-save-file (locate-user-emacs-file "recentf")
                  recentf-max-menu-items 20
                  recentf-max-saved-items 500
                  recentf-exclude '("COMMIT_MSG"
                                    "COMMIT_EDITMSG"
                                    "^/\\(?:ssh\\|su\\|sudo\\)?:"))
          '';
        };

        nxml-mode = {
          enable = true;
          mode = [ ''"\\.xml\\'"'' ];
          config = ''
            (setq nxml-child-indent 4
                  nxml-attribute-indent 4
                  nxml-slash-auto-complete-flag t)
            (add-to-list 'rng-schema-locating-files
                         "~/.emacs.d/nxml-schemas/schemas.xml")
          '';
        };

        systemd = {
          enable = true;
          defer = true;
        };

        treemacs = {
          enable = true;
          bind = {
            "C-c t f" = "treemacs-find-file";
            "C-c t t" = "treemacs";
          };
          init = ''
            (setq treemacs-python-executable "${pkgs.python3}/bin/python")
          '';
        };

        treemacs-projectile = {
          enable = true;
          after = [ "treemacs" "projectile" ];
        };

        hide-mode-line = {
          enable = true;
        };

        vterm = {
          enable = true;
          init = ''
            (defvar vterm-current-title)
          '';
          config = ''
            (add-hook 'vterm-exit-functions
                      (lambda (buffer) (when buffer (kill-buffer buffer))))
            (add-hook 'vterm-mode-hook (lambda ()
                                         (blink-cursor-mode -1)
                                         (setq-local confirm-kill-processes nil)
                                         (hl-line-mode -1)))
          '';
        };

        auth-source-pass = {
          enable = true;
          config = ''
            (setq auth-source-pass-filename "${config.programs.pass.primaryStore.absPath}")
            (auth-source-pass-enable)
          '';
        };

        notmuch = {
          enable = true;
          config = ''
            (setq notmuch-search-oldest-first nil
                  notmuch-archive-tags '("-inbox" "-unread")
                  notmuch-crypto-gpg-program "${pkgs.gnupg}/bin/gpg2"
                  notmuch-command "${pkgs.notmuch}/bin/notmuch"
                  notmuch-address-save-filename "${config.xdg.cacheHome}/notmuch/address-cache"
                  notmuch-mua-cite-function 'message-cite-original-without-signature)
          '';
        };

        shr = {
          enable = true;
          defer = true;
          config = ''
            (setq shr-bullet "• "
                  shr-use-colors nil)
          '';
        };

        janet-mode = {
          enable = true;
          mode = [ ''"\\.janet\\'"'' ];
        };

        rust-mode = {
          enable = true;
          mode = [ ''"\\.rs\\'"'' ];
        };

        gnome-shell-mode = {
          enable = true;
          package = epkgs: (pkgs.emacsPackagesCustom epkgs).gnome-shell-mode;
          command = [ "gnome-shell-mode" ];
          # modeHydra = {
          #   gnome-shell-mode = {
          #     heads = {
          #       Send = {
          #         b = {
          #           command = "gnome-shell-send-buffer";
          #           hint = "buffer";
          #         };
          #       };
          #     };
          #   };
          # };
        };

        css-mode = {
          enable = true;
          package = ""; # built-in
          defer = true;
          config = ''
            (setq css-fontify-colors nil)
          '';
        };

        # Auto-save buffers
        super-save = {
          enable = true;
          config = ''
            (super-save-mode 1)
            (setq super-save-auto-save-when-idle t)
          '';
        };
      };
    };
  };
}
