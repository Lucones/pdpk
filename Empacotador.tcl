#! /bin/env tclsh

package require Tk

#  Janela principal
message .m  -background #C0C0C0
pack .m -expand true -fill both -ipadx 200 -ipady 100
global flag
set flag {0}
#  Barra de menu
menu .menubar
menu .menubar.pdpk -tearoff 0
.menubar add cascade -label PDPK -menu .menubar.pdpk -underline 0
.menubar.pdpk add command -label {Criar Pacote} \
	 -command Criar
.menubar.pdpk add command -label {Instalar Extensão} \
	-command Instalar
.menubar.pdpk add command -label {Adicionar ao Repositório} \
	-command Add_Rep
.menubar.pdpk add command -label {Sobre ...} \
    -accelerator F1 -underline 0 -command Sobre
	
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
proc Sel_Arq { } {
		
	set types {
		{{PD Externals}       *        }
	}
		
	set file [tk_getOpenFile -multiple 1 -filetypes $types -parent .]
	#.t.l configure -text $file
	.t.l configure -state disabled  
	set i 0
	set x 100
	
	foreach j $file {
		incr i
		puts $i
		set y [expr {$i*20 + 40}]
		label .t.l$i -text $j
		place .t.l$i -x 20 -y $y
		.t configure -height [expr {$i*20 + $x + 40}]
		place .t.b1 -x 140 -y [expr {$i*20 + $x}]
	}
	
	destroy .t.l
	#label .t.l1 -text $teste
	#place .t.l1 -x 100 -y 160
	
	#$label configure -text $file
		
	if {$file ne ""} {
		#Comprime os arquivos selecionados num arquivo zip
		exec zip -j package.zip {*}$file
			
		#Ativa o botão para continuar caso selecionado arquivos
		button .t.b2 -text "OK" \
			-command Sel_Doc
		place .t.b2 -x 230 -y [expr {$i*20 + $x }]
	}
}

#Função para criar pacotes
proc Criar {} {

tk::toplevel .t
set oldtitle [wm title .t]
wm title .t "Criar Pacote"
wm resizable .t 1 1 
.t configure -height 160
.t configure -width  300
update
set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
wm geometry  .t +$x+$y
wm transient .t .

label .t.l99 -text "Selecione o(s) arquivo(s)"
place .t.l99 -x 40 -y 5

label .t.l -text "..."
place .t.l -x 20 -y 60

button .t.b -text "Selecionar" \
        -command "Sel_Arq "
place .t.b -x 20 -y 30

button .t.b1 -text "Cancelar" \
        -command {Cancelar .t}
place .t.b1 -x 140 -y 120

 
}
proc Cancelar { .t } {
	destroy .t
	
}

proc Sel_Doc {} {
	# set tl [toplevel .someNameOrOther]
	#set frm [ttk::frame $tl.myFrame]
	destroy .t
tk::toplevel .t
set oldtitle [wm title .t]
wm title .t "Criar Pacote"
wm resizable .t 1 1 
.t configure -height 160
.t configure -width  300
update
set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
wm geometry  .t +$x+$y
wm transient .t .

label .t.l99 -text "Selecione a Documentacao de usuario"
place .t.l99 -x 40 -y 5

label .t.l -text "..."
place .t.l -x 20 -y 60

button .t.b -text "Selecionar" \
        -command "Sel_Arq "
place .t.b -x 20 -y 30

button .t.b1 -text "Cancelar" \
        -command {Cancelar .t}
place .t.b1 -x 140 -y 120



proc Sel_Arq {  } {
	
    set types {
			{{Text Files}       {.txt}        }
		}
    set file [tk_getOpenFile -multiple 0 -filetypes $types -parent .]
   .t.l configure -state disabled  
	set i 0
	set x 100
	
	foreach j $file {
		incr i
		puts $i
		set y [expr {$i*20 + 40}]
		label .t.l$i -text $j
		place .t.l$i -x 20 -y $y
		.t configure -height [expr {$i*20 + $x + 40}]
		place .t.b1 -x 140 -y [expr {$i*20 + $x}]
	}
	
	destroy .t.l

		
	if {$file ne ""} {
		#Comprime os arquivos selecionados num arquivo zip
		#file mkdir "bar"
		#set data "This is some test data.\n"
		#set documentation "Documentation"
		
		#set aeho [open $documentation "w"]
		#puts -nonewline $aeho $data
		
		#exec cp -f $file bar
		#file rename -force $file $documentation
		#file copy $file bar
		
		exec zip -j package.zip $file
	
		#Ativa o botão para continuar caso selecionado arquivos
		button .t.b2 -text "OK" 
		place .t.b2 -x 230 -y [expr {$i*20 + $x }]
	}
	
}

	

		
}
