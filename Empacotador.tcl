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
		set y [expr {$i*20 + 40}]
		label .t.l$i -text $j
		place .t.l$i -x 20 -y $y
		.t configure -height [expr {$i*20 + $x + 40}]
		place .t.b1 -x 140 -y [expr {$i*20 + $x}]
	}
	
	destroy .t.l
	
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
		set y [expr {$i*20 + 40}]
		label .t.l$i -text $j
		place .t.l$i -x 20 -y $y
		.t configure -height [expr {$i*20 + $x + 40}]
		place .t.b1 -x 140 -y [expr {$i*20 + $x}]
	}
	
	destroy .t.l

		
	if {$file ne ""} {
		
		#Cria diretorio temporario para a documentacao
		file mkdir "Documentation"
		#Cria o arquivo temporario para a documentacao
		set documentation "Documentation/Documentation.txt"
		set dir "Documentation"
		
		#Copia o conteudo do arquivo selecionado para o arquivo temporario
		file copy $file $documentation
		
			
		#Comprime o arquivo temporario no arquivo zip
		exec zip package.zip $documentation
		#Deleta os arquivos temporarios
		file delete -force -- $dir
		
		#Ativa o botão para continuar caso selecionado arquivos
		button .t.b2 -text "OK" \
		-command "Metadados "
		place .t.b2 -x 230 -y [expr {$i*20 + $x }]
	}
	
}

	

		
}
proc Metadados {} {
	
	destroy .t
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Criar Pacote"
	wm resizable .t 1 1 
	.t configure -height 560
	.t configure -width  300
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .

	label .t.l99 -text "Preencha os dados indicados"
	place .t.l99 -x 40 -y 5


	label .t.name -text "Name"
	place .t.name -x 20 -y 30
	entry .t.namei
	place .t.namei -x 70 -y 30
	
	label .t.version -text "Version"
	place .t.version -x 20 -y 50
	entry .t.versioni
	place .t.versioni -x 70 -y 50
	
	label .t.author -text "Author"
	place .t.author -x 20 -y 70
	entry .t.authori
	place .t.authori -x 70 -y 70


    labelframe .t.lbl -text "Architecture"
	checkbutton .t.c1 -text "Windows x86"  -variable win32
	checkbutton .t.c2 -text "Windows x64" -variable win64
	checkbutton .t.c3 -text "Linux" -variable linux
	checkbutton .t.c4 -text "MacFag" -variable mac
	pack .t.c1 .t.c2 .t.c3  .t.c4 -in .t.lbl
	place .t.lbl -x 20 -y 200
    
	button .t.b -text "Criar Pacote" -command {
			set ask1 [.t.namei get]
			puts "User: $ask1"

	}
	place .t.b -x 20 -y 150
}
