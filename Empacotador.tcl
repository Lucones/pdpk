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
	.t configure -height 460
	.t configure -width  300
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .

	label .t.lbl1 -text "Preencha os dados indicados"
	place .t.lbl1 -x 80 -y 5
	
	label .t.lbl2 -text "* = optional"
	place .t.lbl2 -x 200 -y 360


	label .t.name -text "Name"
	place .t.name -x 20 -y 30
	entry .t.namei
	place .t.namei -x 110 -y 30
	
	label .t.sum -text "Summary"
	place .t.sum -x 20 -y 50
	entry .t.sumi
	place .t.sumi -x 110 -y 50
	
	label .t.author -text "Author"
	place .t.author -x 20 -y 70
	entry .t.authori
	place .t.authori -x 110 -y 70
	
	label .t.version -text "Version"
	place .t.version -x 20 -y 90
	entry .t.versioni -validate key -vcmd {string is double %P}
	place .t.versioni -x 110 -y 90	
	
    labelframe .t.lbl -text "Architecture" -padx 0 
	checkbutton .t.c1 -text "Windows x86"  -variable win32
	checkbutton .t.c2 -text "Windows x64" -variable win64
	checkbutton .t.c3 -text "Linux" -variable linux 
	checkbutton .t.c4 -text "MacFag" -variable mac  
	pack .t.c1 .t.c2 .t.c3  .t.c4 -in .t.lbl -anchor w	
	place .t.lbl -x 120 -y 115
	
	label .t.license -text "License"
	place .t.license -x 20 -y 230
	entry .t.licensei
	place .t.licensei -x 110 -y 230
	
	label .t.type -text "Type"
	place .t.type -x 20 -y 250
	entry .t.typei
	place .t.typei -x 110 -y 250
	
	 label .t.source -text "Source"
	place .t.source -x 20 -y 270
	entry .t.sourcei
	place .t.sourcei -x 110 -y 270
	
	label .t.description -text "Description"
	place .t.description -x 20 -y 290
	entry .t.descriptioni
	place .t.descriptioni -x 110 -y 290
	
	label .t.dependecies -text "Dependecies*"
	place .t.dependecies -x 20 -y 310
	entry .t.dependeciesi
	place .t.dependeciesi -x 110 -y 310
	
	label .t.conflicts -text "Conflicts*"
	place .t.conflicts -x 20 -y 330
	entry .t.conflictsi 
	place .t.conflictsi -x 110 -y 330
	
	button .t.b1 -text "Cancelar" \
			-command {Cancelar .t}
	place .t.b1 -x 80 -y 400
    
		
		
		
		button .t.b -text "Criar Pacote" \
				-command {
					set name [.t.namei get]
					set sum [.t.sumi get]
					set author [.t.authori get]
					set version [.t.versioni get]
					set license [.t.licensei get]
					set type [.t.typei get]
					set source [.t.sourcei get]
					set description [.t.descriptioni get]
					set dependecies [.t.dependeciesi get]
					set conflicts [.t.conflictsi get]
					if { $name ne "" && $sum ne "" && $author ne "" && $version ne "" && $license ne "" && $type ne "" && $source ne "" && $description ne ""} {
						set descriptor "Descriptor.txt"
						set outfile [open "Descriptor.txt" w]
						
						puts $outfile "Name: $name "
						puts $outfile "Summary: $sum "
						puts $outfile "Author: $author "
						puts $outfile "Version: $version "
						puts $outfile "License: $license "
						puts $outfile "Type: $type "
						puts $outfile "Source: $source "
						puts $outfile "Description: $description "
						puts $outfile "Dependecies: $dependecies "
						puts $outfile "Conflicts: $conflicts "
						
						close $outfile
						
						
						exec zip package.zip $descriptor
						file delete -force -- $descriptor
						tk_messageBox -message "Pacote criado com sucesso!" -type ok
						destroy .t
				
					} else {
						tk_messageBox -message "Please fill all the data!" -type ok
					}
					}
		place .t.b -x 170 -y 400
	
	
	
}
