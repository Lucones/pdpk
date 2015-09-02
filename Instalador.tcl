#! /bin/env tclsh

package require Tk

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

proc Instalar {} {
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

	label .t.l99 -text "Select the Pure Data package"
	place .t.l99 -x 30 -y 5

	label .t.l -text "..."
	place .t.l -x 20 -y 60

	button .t.b -text "Select" \
			-command "Sel_Arq"
	place .t.b -x 20 -y 30

	button .t.b1 -text "Cancel" \
			-command {Cancelar .t}
	place .t.b1 -x 140 -y 120
}

proc Cancelar { .t } {
	destroy .t
	
}

proc Sel_Arq { } {
	
	set types {
			{{Pure Data package files}       {.pdpk}        }
		}
    set file [tk_getOpenFile -multiple 0 -filetypes $types -parent .]
	
	set len [string length $file]
	if { $len > 40 } {
		set len1 [expr {$len - 40}]
		.t configure -width [expr {300 + 8 * $len1}]
	}
	if [winfo exists .t.l1] {
			destroy .t.l1
			destroy .t.b2
	}
	label .t.l1 -text $file
	place .t.l1 -x 20 -y 60
	destroy .t.l
	
		
	if {$file ne ""} {
		
		#Ativa o botão para continuar caso selecionado arquivos
		button .t.b2 -text "OK" \
		-command "Extrair $file"
		place .t.b2 -x 220 -y 120
	}
	
}
proc Extrair { filer } {
	
		set file [ file tail $filer ]
		regsub -all ".pdpk" $file {} finalname
		
		file mkdir $finalname
		exec unzip $filer -d $finalname
		
		#exec unzip $filer -d $dir1
		file rename -force -- "$finalname/Descriptor.txt" "$finalname-Descriptor.txt"
		file rename -force -- "$finalname/Documentation/Documentation.txt" "$finalname-Documentation.txt"
		
		set dir ""
		set answer [tk_messageBox -message "Please, select the installation folder" -type okcancel]
			switch -- $answer {
			   ok { set dir [tk_chooseDirectory \
        -initialdir "~/pd-externals" -title "Choose an installation directory"] }
			   cancel { Cancelar .t}
			 }
		if { $dir ne "" } {
			
			file copy -force -- "$finalname-Descriptor.txt" $dir 
			set dir1 "$dir/Documentation/"
			if {![file isdirectory $dir1]} {			  
			  file mkdir $dir1
			}
			file copy -force -- "$finalname-Documentation.txt" $dir1
			file delete -force -- "$finalname/Documentation/"
			file copy -force -- "$finalname" $dir
			file delete -force -- "$finalname-Descriptor.txt"
			file delete -force -- "$finalname"
			file delete -force -- "$finalname-Documentation.txt"

		}
}
