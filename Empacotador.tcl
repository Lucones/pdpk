#! /bin/env tclsh
 package require Tk
 package require tablelist 
 package require http
 package require tls
 
package provide Empacotador
	#  Janela principal
	message .m  -background #C0C0C0
	pack .m -expand true -fill both -ipadx 200 -ipady 100
	set var 0
	set finalnewfile 0
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
	.menubar.pdpk add command -label {Create Repository} \
		-command Create_Rep
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


#Função para criar pacotes
proc Criar {} {
	
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Create Package"
	wm resizable .t 0 0 
	.t configure -height 400
	.t configure -width  800
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .

	

					frame .t.frm
					labelframe .t.frm.lbf -text "Select the Pure Data externals file(s)" -padx 0 -width 57
					tablelist::tablelist .t.frm.lbf.mlb -selectmode multiple -columns {0 "File"} \
					-stretch all -background white -width 57 -xscroll {.t.frm.lbf.h set} -yscroll {.t.frm.lbf.v set}  -showseparators true 					

					scrollbar .t.frm.lbf.v -orient vertical   -command {.t.frm.lbf.mlb yview}
					scrollbar .t.frm.lbf.h -orient horizontal -command {.t.frm.lbf.mlb xview}

					# Tell the text widget to take all the extra room
					# Lay them out
					grid .t.frm.lbf -sticky nsew

					grid .t.frm.lbf.mlb .t.frm.lbf.v -sticky nsew
					grid .t.frm.lbf.h                -sticky nsew

					# Tell the tablelist widget to take all the extra room
					grid rowconfigure    .t.frm.lbf .t.frm.lbf.mlb -weight 1
					grid columnconfigure .t.frm.lbf .t.frm.lbf.mlb -weight 1

					place .t.frm -x 10 -y 15
					
					frame .t.frm1
					
					button .t.badd -text "Add"\
							-command {
								set types {
									{{PD Externals}       *        }
								}
								set file [tk_getOpenFile -initialdir ~ -multiple 1 -filetypes $types -parent .]
								
								if {$file ne ""} {
									foreach fils $file {
										.t.frm.lbf.mlb insert end [list "$fils"]
									}
								}
							}
					pack .t.badd -in .t.frm1 -side left
					
					button .t.brem -text "Remove Selected"\
							-command {
								set sele [.t.frm.lbf.mlb curselection]
								.t.frm.lbf.mlb delete $sele
							}
							
					pack .t.brem -in .t.frm1 -side left
					
					grid .t.frm1 -in .t.frm.lbf
    

	labelframe .t.lbl1 -text "Fill all the blanks"
	place .t.lbl1 -x 520 -y 15

	frame .t.frmname
	label .t.name -text "Name"	
	entry .t.namei	
	pack .t.name .t.namei -in .t.frmname -side left
	pack .t.frmname -in .t.lbl1 -anchor e
	
	frame .t.frmsum
	label .t.sum -text "Summary"
	entry .t.sumi
	pack .t.sum .t.sumi -in .t.frmsum -side left
	pack .t.frmsum -in .t.lbl1 -anchor e
	
	frame .t.frmauthor
	label .t.author -text "Author"
	entry .t.authori
	pack .t.author .t.authori -in .t.frmauthor -side left
	pack .t.frmauthor -in .t.lbl1 -anchor e

	frame .t.frmversion	
	label .t.version -text "Version"
	entry .t.versioni -validate key -vcmd {string is double %P}
	pack .t.version .t.versioni -in .t.frmversion -side left
	pack .t.frmversion -in .t.lbl1 -anchor e
	
    labelframe .t.lbl -text "Supported Architectures" -padx 0 
	checkbutton .t.c1 -text "Windows x86"  -variable win32
	checkbutton .t.c2 -text "Windows x64" -variable win64
	checkbutton .t.c3 -text "Linux" -variable linux 
	checkbutton .t.c4 -text "Mac OS" -variable mac  
	pack .t.c1 .t.c2 .t.c3  .t.c4 -in .t.lbl -anchor w	
	pack .t.lbl -in .t.lbl1 -anchor e
	
	frame .t.frmlicense
	label .t.license -text "License"
	entry .t.licensei
	pack .t.license .t.licensei -in .t.frmlicense -side left
	pack .t.frmlicense -in .t.lbl1 -anchor e
	
	frame .t.frmtype
	label .t.type -text "Type"
	entry .t.typei
	pack .t.type .t.typei -in .t.frmtype -side left
	pack .t.frmtype -in .t.lbl1 -anchor e
	
	frame .t.frmsource
	label .t.source -text "Source"
	entry .t.sourcei
	pack .t.source .t.sourcei -in .t.frmsource -side left
	pack .t.frmsource -in .t.lbl1 -anchor e
	
	frame .t.frmdescription
	label .t.description -text "Description"
	entry .t.descriptioni
	pack .t.description .t.descriptioni -in .t.frmdescription -side left
	pack .t.frmdescription -in .t.lbl1 -anchor e
	
	frame .t.frmdependecies
	label .t.dependecies -text "Dependecies*"
	entry .t.dependeciesi
	pack .t.dependecies .t.dependeciesi -in .t.frmdependecies -side left
	pack .t.frmdependecies -in .t.lbl1 -anchor e
	
	frame .t.frmconflicts
	label .t.conflicts -text "Conflicts*"
	entry .t.conflictsi 
	pack .t.conflicts .t.conflictsi -in .t.frmconflicts -side left
	pack .t.frmconflicts -in .t.lbl1 -anchor e

	label .t.lbl2 -text "* = optional"
	pack .t.lbl2 -in .t.lbl1 
	
	button .t.b1 -text "Cancel" \
			-command {Cancelar .t}
	place .t.b1 -x 40 -y 320
	
	button .t.b2 -text "Create Package" \
			-command {
				set file [.t.frm.lbf.mlb getcolumns 0]
				
				if { $file eq "" } {
					tk_messageBox -message "Please Select the Pure Data externals file(s)!" -type ok
				} else {
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
						append arch "Windows64_"
					}
					if { $win32 == 1 } {
						append arch "Windows32_"
					}
					if { $linux == 1 } {
						append arch "Linux_"
					}
					if { $mac == 1 } {
						append arch "Mac_"
					}					
					
					if { $name ne "" && $sum ne "" && $author ne "" && $version ne "" && $license ne "" && $type ne "" && $source ne "" && $description ne "" } {
						if { $win32 == 1 || $win64 == 1 || $linux == 1 || $mac == 1 } {
							
							foreach fils $file {
								
								exec zip -j package.zip {*}$fils
								
							}
							
							set descriptor "Descriptor.txt"
							set outfile [open "Descriptor.txt" w]
							set systemTime [clock seconds] 
							
							set finalarch [string trimright $arch "_"]
							
							puts $outfile "Name: $name"
							puts $outfile "Summary: $sum"
							puts $outfile "Author: $author"
							puts $outfile "Version: $version"
							puts $outfile "Supported Architectures: $finalarch"						
							puts $outfile "Date Created: [clock format $systemTime -format %D] - [clock format $systemTime -format %H:%M:%S]"
							puts $outfile "License: $license"
							puts $outfile "Type: $type"
							puts $outfile "Source: $source"
							puts $outfile "Description: $description"
							puts $outfile "Dependecies: $dependecies"
							puts $outfile "Conflicts: $conflicts"
							
							close $outfile
							
							exec zip package.zip $descriptor
							file delete -force -- $descriptor
							regsub -all {\s} $name {_} finalname
							regsub -all {\s} $version {_} finalversion
							file rename -force -- "package.zip" "$finalname-$version-$finalarch.pdpk"
							
							set newfile "$finalname-$version-$finalarch.pdpk"
							regsub -all {_.pdpk} $newfile {.pdpk} finalnewfile
							
							file rename -force -- $newfile $finalnewfile
							#puts $newfile
							
							destroy .t
							
							if {![file isdirectory "~/pd-externals/packages"]} {			  
								file mkdir "~/pd-externals/packages"
							}
							set dir "~/pd-externals/packages"
								
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
				
				
				}
	place .t.b2 -x 140 -y 320
	
 
}
proc Cancelar { .t } {
	destroy .t
	
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
	checkbutton .t.c4 -text "Mac OS" -variable mac  
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
	place .t.description -x 20 -y 330
	entry .t.descriptioni
	place .t.descriptioni -x 110 -y 330
	
	label .t.dependecies -text "Dependecies*"
	place .t.dependecies -x 20 -y 290
	entry .t.dependeciesi
	place .t.dependeciesi -x 110 -y 290
	
	label .t.conflicts -text "Conflicts*"
	place .t.conflicts -x 20 -y 310
	entry .t.conflictsi 
	place .t.conflictsi -x 110 -y 310
	
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
						append arch "Windows64_"
					}
					if { $win32 == 1 } {
						append arch "Windows32_"
					}
					if { $linux == 1 } {
						append arch "Linux_"
					}
					if { $mac == 1 } {
						append arch "Mac_"
					}
					
					
					
					if { $name ne "" && $sum ne "" && $author ne "" && $version ne "" && $license ne "" && $type ne "" && $source ne "" && $description ne "" } {
						if { $win32 == 1 || $win64 == 1 || $linux == 1 || $mac == 1 } {
							set descriptor "Descriptor.txt"
							set outfile [open "Descriptor.txt" w]
							set systemTime [clock seconds] 
							
							set finalarch [string trimright $arch "_"]
							
							puts $outfile "Name: $name"
							puts $outfile "Summary: $sum"
							puts $outfile "Author: $author"
							puts $outfile "Version: $version"
							puts $outfile "Supported Architectures: $finalarch"						
							puts $outfile "Date Created: [clock format $systemTime -format %D]"
							puts $outfile "License: $license"
							puts $outfile "Type: $type"
							puts $outfile "Source: $source"
							puts $outfile "Description: $description"
							puts $outfile "Dependecies: $dependecies"
							puts $outfile "Conflicts: $conflicts"
							
							close $outfile
							
							
							exec zip package.zip $descriptor
							file delete -force -- $descriptor
							regsub -all {\s} $name {_} finalname
							#regsub -all {\s} $arch {_} finalarch 
							regsub -all {\s} $version {_} finalversion
							file rename -force -- "package.zip" "$finalname-$version-$finalarch.pdpk"
							
							set newfile "$finalname-$version-$finalarch.pdpk"
							regsub -all {_.pdpk} $newfile {.pdpk} finalnewfile
							
							file rename -force -- $newfile $finalnewfile
							#puts $newfile
							
							destroy .t
							
							if {![file isdirectory "~/pd-externals/packages"]} {			  
								file mkdir "~/pd-externals/packages"
							}
							set dir "~/pd-externals/packages"
								
								file copy -force -- $finalnewfile $dir 
							
								file delete -force -- $finalnewfile
								
								set path ""
								
								append path $dir "/" $finalnewfile
								
							
					
								#"~/pd-externals/packages/$finalname-$version-$finalarch.pdpk"
								
							tk_messageBox -message "Package created sucessfully!" -type ok	
							
							#set answer [tk_messageBox -message "Would you like to add this package to a remote repository?" -type yesno -icon question]
						#		switch -- $answer {
					#			yes " Add_Rep $path "
				#				no exit
			#				}

							
							} else {
								tk_messageBox -message "Please fill all the blanks!" -type ok
							}
					
					} else {
						tk_messageBox -message "Please fill all the blanks!" -type ok
					}
					}
		place .t.b -x 160 -y 400
	
	
	
}
proc Create_Rep {  }  {

	destroy .t
	set ::reptype 0

	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Add to repository"
	wm resizable .t 0 0 
	.t configure -height 160
	.t configure -width  700
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .

	label .t.l99 -text "Select the Repository Folder"
	place .t.l99 -x 30 -y 5
	
	##
	
	
	label .t.l -text "..."
	place .t.l -x 20 -y 60

	button .t.b -text "Select" \
			-command { Sel_Arq }
	place .t.b -x 20 -y 30

	button .t.b1 -text "Cancel" \
			-command {Cancelar .t}
	place .t.b1 -x 140 -y 120

proc Sel_Arq {  } {
	
    set dirSel [tk_chooseDirectory -initialdir "~/"]
  
	set i 0
	set x 100
	
	set len [string length $dirSel]
	
	if { $len > 40 } {
		set len1 [expr {$len - 40}]
		.t configure -width [expr {300 + 8 * $len1}]
	}
	
	
		 if [winfo exists .t.l$i] {
			destroy .t.l$i
			destroy .t.b2
		}
		
		label .t.l$i -text $dirSel
		place .t.l$i -x 20 -y 60
	
	
	#destroy .t.l

		
	if {$dirSel ne ""} {
		
		#Ativa o botão para continuar caso selecionado arquivos
		button .t.b2 -text "Create Repository" \
		-command " Sel_Rep $dirSel "	
		place .t.b2 -x 220 -y 120
	}
	
}
}

				
		
		
		

proc Sel_Rep { dir } {
	
	#destroy .t.l
	set flag 0
	#puts $dir
	
	if { ![file exist "$dir/RepositoryDescriptor.txt"] } {
		set answer [tk_messageBox -message "This is not a native repository.\n Would you like to make it so?" -type yesno -icon question]
				switch -- $answer {
					yes {
						set root "~/"
						set owner [file tail $root]

						set RepDes "$dir/RepositoryDescriptor.txt"
						set outfile [open "$dir/RepositoryDescriptor.txt" w]
						set systemTime [clock seconds]
									
						puts $outfile "Owner: $owner "
						puts $outfile "Date Created: [clock format $systemTime -format %D] - [clock format $systemTime -format %H:%M:%S] "
					
						close $outfile
					}
					no exit
				}
		

	} else {
		set f [open "$dir/RepositoryDescriptor.txt"]
			while {[gets $f line] != -1} {
				if {[regexp {Owner:\s+(.*)} $line all owner]} {
				
				}
				 if {[regexp {Date Created:\s+(.*)} $line all date]} {
		
				}			
			}		
		close $f
		set outfile [open "$dir/RepositoryDescriptor.txt" w]
			puts $outfile "Owner: $owner "
			puts $outfile "Date Created: $date "
		close $outfile	
		
	}
	set outfile [open "$dir/RepositoryDescriptor.txt" a+]
	set systemTime [clock seconds]
		
	puts $outfile "Last Modified: [clock format $systemTime -format %D] - [clock format $systemTime -format %H:%M:%S] \n"
	#puts $outfile "\nMD5: \t/Name: \t\t/Version: \t/Architectures: \t\t/Summary: \t/Type/Group: "
	
	close $outfile
	
	proc ::findFiles { baseDir pattern } {
	  set dirs [ glob -nocomplain -type d [ file join $baseDir * ] ]
	  set files {}
	  foreach dir $dirs { 
		lappend files {*}[ findFiles $dir $pattern ] 
	  }
	  lappend files {*}[ glob -nocomplain -type f [ file join $baseDir $pattern ] ]

	return $files
	}

set fileser [ join [ findFiles $dir "*.pdpk" ] \n ]
foreach fils $fileser {
	set filename [file tail $fils]
	file delete -force -- "Descriptor.txt"	
	exec unzip -j $filename "Descriptor.txt" -d ""

	set f [open "Descriptor.txt"]
		while {[gets $f line] != -1} {
			if {[regexp {Summary:\s+(.*)} $line all summary]} {
					regsub -all {\s} $summary {_} summary
			}
			 if {[regexp {Type:\s+(.*)} $line all type]} {
					regsub -all {\s} $type {_} type
			}
			if {[regexp {Version:\s+(.*)} $line all version]} {
					regsub -all {\s} $version {_} version
			}
			if {[regexp {Name:\s+(.*)} $line all name]} {
						regsub -all {\s} $name {_} name
			}
			if {[regexp {Supported Architectures:\s+(.*)} $line all arch]} {
			
			}
			
		}
		
	close $f
	file delete -force -- "Descriptor.txt"
	set outfile [open "$dir/RepositoryDescriptor.txt" a+]
			puts $outfile "$filename \t/$name \t/$version \t/$arch \t/$summary \t/$type \t"
	
	close $outfile
	
	
}
tk_messageBox -message "Repository Descriptor ready! \nPlease upload to a personal host" -type ok
}
proc New_Rep { dir } {
	destroy .t	

 puts $dir		
	
	tk::toplevel .t
						set oldtitle [wm title .t]
						wm title .t "Enter Your Name"
						wm resizable .t 0 0 
						.t configure -height 160
						.t configure -width  400
						update
						set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
						set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
						wm geometry  .t +$x+$y
						wm transient .t .
						
						entry .t.ename -width 30 
						place .t.ename -x 100 -y 50
						
						
						label .t.lname -text "Name"
						place .t.lname -x 30 -y 50
												
						button .t.b -text "Add to repository" \
							-command { Aeho	$dir }
						place .t.b -x 30 -y 80					

}
proc Aeho { dir } {
	puts dir
}
