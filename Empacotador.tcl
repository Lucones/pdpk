#! /bin/env tclsh

package require Tk


#  Create the main message window
message .m  -background #C0C0C0
pack .m -expand true -fill both -ipadx 200 -ipady 100

#  Create the main menu bar with a Help-About entry
menu .menubar
menu .menubar.help -tearoff 0
menu .menubar.file -tearoff 0
.menubar add cascade -label Help -menu .menubar.help -underline 0
.menubar.help add command -label {About Hello ...} \
    -accelerator F1 -underline 0 -command showAbout

.menubar add cascade -label File -menu .menubar.file -underline 0
.menubar.file add command -label {Add File} \
    -accelerator F4 -underline 0 -command File

menu .menubar.pdpk -tearoff 0
.menubar add cascade -label PDPK -menu .menubar.pdpk -underline 0
.menubar.pdpk add command -label {Criar Pacote} \
	 -command Sel_Arq
.menubar.pdpk add command -label {Instalar Extensão} \
	-command demo
.menubar.pdpk add command -label {Adicionar ao Repositório} \
	-command showAbout
	
#  Configure the main window 
wm title . {Hello Foundation Application}
. configure -menu .menubar -width 200 -height 150
bind . {<Key F1>} {showAbout}

#  Define a procedure - an action for Help-About
proc showAbout {} {
    tk_messageBox -message "Tcl/Tk\nHello Windows\nVersion 1.0" \
        -title {About Hello}
}
proc Instalar {} {
    tk_messageBox -message "Tcl/Tk\nHello Windows\nVersion 1.0" \
        -title {teste}
}
proc Sel_Arq {} {
	global flag
		set flag {disabled}
        
proc onSelect { label } {
	
    set types {
    {{Text Files}       {.txt}        }}
    set file [tk_getOpenFile -multiple 1 -filetypes $types -parent .]
    $label configure -text $file
   #set flag {active}
	
	if {$file ne ""} {
    
		button .b2 -text "OK" \
			-command Sel_Doc
		place .b2 -x 290 -y 180

	}
	
}

label .l -text "..."
place .l -x 20 -y 60

button .b -text "Selecione o arquivo" \
        -command "onSelect .l"
place .b -x 20 -y 30

button .b1 -text "Cancelar" \
        -command main
place .b1 -x 220 -y 180




#wm title . "Selecionar Arquivo" 
#. configure -menu .menubar -width 200 -height 150 
}
