#! /bin/env tclsh

package require Tk
package provide Empacotador
	#  Janela principal
	message .m  -background #C0C0C0
	pack .m -expand true -fill both -ipadx 200 -ipady 100
	set var 0
	global flag
	set flag {0}
	#  Barra de menu
	menu .menubar
	menu .menubar.pdpk -tearoff 0
	.menubar add cascade -label PDPK -menu .menubar.pdpk -underline 0
	.menubar.pdpk add command -label {Create Package} \
		 -command Criar
	.menubar.pdpk add command -label {Install External} \
		-command Instalar
	.menubar.pdpk add command -label {Add to repository} \
		-command Add_Rep
	.menubar.pdpk add command -label {About ...} \
		-accelerator F1 -underline 0 -command Sobre
		
	#  Configuração do menu
	wm title . {Hello Foundation Application}
	. configure -menu .menubar -width 200 -height 150

	bind . {<Key F1>} {Sobre}


proc Sobre {} {
    tk_messageBox -message "pdpk version 1.0" \
        -title {Sobre}
}
#Função para instalar pacotes
proc Instalar {} {

}
proc Add_Rep {} {

}

#Função para criar pacotes
proc Criar {} {
	
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Create Package"
	wm resizable .t 0 0 
	.t configure -height 160
	.t configure -width  300
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .

	label .t.l99 -text "Select the Pure Date externals file(s)"
	place .t.l99 -x 30 -y 5

	label .t.l -text "..."
	place .t.l -x 20 -y 60

	button .t.b -text "Select" \
			-command "Sel_Arq var"
	place .t.b -x 20 -y 30

	button .t.b1 -text "Cancel" \
			-command {Cancelar .t}
	place .t.b1 -x 140 -y 120
	
	proc Sel_Arq { varname } {
		
	set types {
		{{PD Externals}       *        }
	}
		
	set file [tk_getOpenFile -initialdir ~ -multiple 1 -filetypes $types -parent .]
	set i 0
	set x 100
	set len1 0
	foreach j $file {
		incr i
		 if [winfo exists .t.l$i] {
			destroy .t.l$i
			destroy .t.b2
		}
		set len [string length $j]
	
		if { $len > 40 } {
			if {$len > $len1 } {
				set len1 $len
				set len2 [expr {$len1 - 40}]
				.t configure -width [expr {300 + 8 * $len2}]
			}
		}
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
		place .t.b2 -x 220 -y [expr {$i*20 + $x }]
	}
}

 
}
proc Cancelar { .t } {
	destroy .t
	
}

proc Sel_Doc {} {
		destroy .t
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Create Package"
	wm resizable .t 1 1 
	.t configure -height 160
	.t configure -width  300
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .

	label .t.l99 -text "Select the user documentation file"
	place .t.l99 -x 30 -y 5

	label .t.l -text "..."
	place .t.l -x 20 -y 60

	button .t.b -text "Select" \
			-command "Sel_Arq "
	place .t.b -x 20 -y 30

	button .t.b1 -text "Cancel" \
			-command {Cancelar .t}
	place .t.b1 -x 140 -y 120



proc Sel_Arq {  } {
	
    set types {
			{{Text Files}       {.txt}        }
		}
    set file [tk_getOpenFile -initialdir ~ -multiple 0 -filetypes $types -parent .]
  
	set i 0
	set x 100
	
	set len [string length $file]
	if { $len > 40 } {
		set len1 [expr {$len - 40}]
		.t configure -width [expr {300 + 8 * $len1}]
	}
	
	
		 if [winfo exists .t.l$i] {
			destroy .t.l$i
			destroy .t.b2
		}
		
		label .t.l$i -text $file
		place .t.l$i -x 20 -y 60
	
	
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
		place .t.b2 -x 220 -y 120
	}
	
}

	

		
}
proc Metadados {} {
	
	destroy .t
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Create Package"
	wm resizable .t 1 1 
	.t configure -height 460
	.t configure -width  300
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .

	label .t.lbl1 -text "Fill all the blanks"
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
	
    labelframe .t.lbl -text "Supported Architectures" -padx 0 
	checkbutton .t.c1 -text "Windows x86"  -variable win32
	checkbutton .t.c2 -text "Windows x64" -variable win64
	checkbutton .t.c3 -text "Linux" -variable linux 
	checkbutton .t.c4 -text "MacFag" -variable mac  
	pack .t.c1 .t.c2 .t.c3  .t.c4 -in .t.lbl -anchor w	
	place .t.lbl -x 110 -y 115
	
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
	
	button .t.b1 -text "Cancel" \
			-command {Cancelar .t}
	place .t.b1 -x 80 -y 400
    
		
		
		
		button .t.b -text "Create Package" \
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

					set arch ""
					if { $win64 == 1 } {
						append arch "Windows 64 "
					}
					if { $win32 == 1 } {
						append arch "Windows 32 "
					}
					if { $linux == 1 } {
						append arch "Linux "
					}
					if { $mac == 1 } {
						append arch "Mac "
					}
					
					
					
					if { $name ne "" && $sum ne "" && $author ne "" && $version ne "" && $license ne "" && $type ne "" && $source ne "" && $description ne "" } {
						if { $win32 == 1 || $win64 == 1 || $linux == 1 || $mac == 1 } {
							set descriptor "Descriptor.txt"
							set outfile [open "Descriptor.txt" w]
							set systemTime [clock seconds] 
							
							puts $outfile "Name: $name "
							puts $outfile "Summary: $sum "
							puts $outfile "Author: $author "
							puts $outfile "Version: $version "
							puts $outfile "Supported Architectures: $arch "						
							puts $outfile "Date Created: [clock format $systemTime -format %D]"
							puts $outfile "License: $license "
							puts $outfile "Type: $type "
							puts $outfile "Source: $source "
							puts $outfile "Description: $description "
							puts $outfile "Dependecies: $dependecies "
							puts $outfile "Conflicts: $conflicts "
							
							close $outfile
							
							
							exec zip package.zip $descriptor
							file delete -force -- $descriptor
							regsub -all {\s} $name {_} finalname
							regsub -all {\s} $arch {_} finalarch 
							regsub -all {\s} $version {_} finalversion
							file rename -force -- "package.zip" "$finalname-$version-$finalarch.pdpk"
							puts "$finalname-$version-$finalarch.pdpk"
							set newfile "$finalname-$version-$finalarch.pdpk"
							regsub -all {_.pdpk} $newfile {.pdpk} finalnewfile
							puts "$finalnewfile"
							file rename -force -- $newfile $finalnewfile
							#puts $newfile
							tk_messageBox -message "Please, select the destination folder" -type ok
							destroy .t
							set dir [tk_chooseDirectory \
								-initialdir ~ -title "Choose the destination folder"]
								
								file copy -force -- $finalnewfile $dir
								
								file delete -force -- $finalnewfile
							tk_messageBox -message "Package created sucessfully!" -type ok	
							} else {
								tk_messageBox -message "Please fill all the blanks!" -type ok
							}
					
					} else {
						tk_messageBox -message "Please fill all the blanks!" -type ok
					}
					}
		place .t.b -x 160 -y 400
	
	
	
}

