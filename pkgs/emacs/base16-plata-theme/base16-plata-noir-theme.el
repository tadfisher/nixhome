;; base16-plata-noir-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/chriskempson/base16)

;;; Authors:
;; Scheme: Tad Fisher
;; Template: Kaleb Elwert <belak@coded.io>

;;; Code:

(require 'base16-theme)

(defvar base16-plata-noir-colors
  '(:base00 "#111111"
    :base01 "#1d1d1d"
    :base02 "#3f51b5"
    :base03 "#8c8c8c"
    :base04 "#b8b8b8"
    :base05 "#f5f5f5"
    :base06 "#f5f5f5"
    :base07 "#ffffff"
    :base08 "#f44336"
    :base09 "#ff9800"
    :base0A "#ffcb6b"
    :base0B "#c3e88d"
    :base0C "#1de9b6"
    :base0D "#52b2ff"
    :base0E "#8796ed"
    :base0F "#ab7967")
  "All colors for Base16 Plata Noir are defined here.")

;; Define the theme
(deftheme base16-plata-noir)

;; Add all the faces to the theme
(base16-theme-define 'base16-plata-noir base16-plata-noir-colors)

;; Mark the theme as provided
(provide-theme 'base16-plata-noir)

(provide 'base16-plata-noir-theme)

;;; base16-plata-noir-theme.el ends here
