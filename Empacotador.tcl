#! /bin/env tclsh

package require Tk


#  Janela principal
message .m  -background #C0C0C0
pack .m -expand true -fill both -ipadx 200 -ipady 100

#  Barra de menu
menu .menubar
menu .menubar.help -tearoff 0
menu .menubar.file -tearoff 0
.menubar add cascade -label Help -menu .menubar.help -underline 0
.menubar.help add command -label {About Hello ...} \
    -accelerator F1 -underline 0 -command Sobre

.menubar add cascade -label File -menu .menubar.file -underline 0
.menubar.file add command -label {Add File} \
    -accelerator F4 -underline 0 -command File

menu .menubar.pdpk -tearoff 0
.menubar add cascade -label PDPK -menu .menubar.pdpk -underline 0
.menubar.pdpk add command -label {Criar Pacote} \
	 -command Sel_Arq
.menubar.pdpk add command -label {Instalar Extensão} \
	-command Instalar
.menubar.pdpk add command -label {Adicionar ao Repositório} \
	-command Add_Rep
	
#  Configuração do menu
wm title . {Hello Foundation Application}
. configure -menu .menubar -width 200 -height 150
bind . {<Key F1>} {Sobre}


proc Sobre {} {
    tk_messageBox -message "pdpk versão 1.0" \
        -title {Sobre}
}
#Função para instalar pacotes
proc Instalar {} {

}
proc Add_Rep {} {

}
#Função para criar pacotes
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
		#Ativa o botão para continuar caso selecionado arquivos
		button .b2 -text "OK" \
			-command Sel_Doc
		place .b2 -x 290 -y 180

	}
	
}

label .l -text "..."
place .l -x 20 -y 60

button .b -text "Selecione o(s) arquivo(s)" \
        -command "onSelect .l"
place .b -x 20 -y 30

button .b1 -text "Cancelar" \
        -command main
place .b1 -x 220 -y 180

 
}
