#! /bin/env tclsh
 package require Tk
 package require tablelist 
 package require http
 package require tls
 

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
	.menubar.pdpk add command -label {Remove Package} \
		 -command Remover
	.menubar.pdpk add command -label {Install External} \
		-command Instalar
	.menubar.pdpk add command -label {Uninstall External} \
		-command Desinstalar
	.menubar.pdpk add command -label {Create Repository} \
		-command RepType
	.menubar.pdpk add command -label {Download Packages} \
		-command Download
	.menubar.pdpk add command -label {Check for Updates} \
		-command Atualizar
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
	destroy .t
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Install Package"
	wm resizable .t 0 0 
	.t configure -height 400
	.t configure -width  800
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .

					frame .t.frm
					labelframe .t.frm.lbf -text "Select the Package(s)" -padx 0 -width 57
					tablelist::tablelist .t.frm.lbf.mlb -selectmode multiple -columns {0 "Package"} \
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
										{{Pure Data package files}       {.pdpk}        }
								}
								set file [tk_getOpenFile -initialdir ~ -multiple 1 -filetypes $types -parent .]
								
								if {$file ne ""} {
									foreach fils $file {
										#set filer [ file tail $fils ]
										.t.frm.lbf.mlb insert end [list "$fils"]
									}
								}
							}
					pack .t.badd -in .t.frm1 -side left	
					grid .t.frm1 -in .t.frm.lbf
					
					button .t.brem -text "Remove Selected"\
							-command {
								set sele [.t.frm.lbf.mlb curselection]
								.t.frm.lbf.mlb delete $sele
							}
							
					pack .t.brem -in .t.frm1 -side left
					
					grid .t.frm1 -in .t.frm.lbf
					
					button .t.b1 -text "Cancel" \
							-command {Cancelar .t}
					place .t.b1 -x 40 -y 320
	
					button .t.b2 -text "Install Package(s)" \
							-command {
								set file [.t.frm.lbf.mlb getcolumns 0]
				
								if { $file eq "" } {
									tk_messageBox -message "Please Select the Package(s)!" -type ok
								} else {
									set dir "~/pd-externals"
									foreach fils $file {
										set filer [ file tail $fils ]
										regsub -all ".pdpk" $filer {} finalname
									
										if {![file isdirectory "~/pd-externals/$finalname"]} {
											
												#Cria uma pasta temporária e extrai os arquivos nela
												file delete -force -- "$finalname"		
												file mkdir $finalname												
												exec unzip $fils -d $finalname
												
													
												#Adiciona o horário do sistema no descritor, indicando a hora e data da instalação
												set descriptor "$finalname/Descriptor.txt"
												set outfile [open "$finalname/Descriptor.txt" a+]
												set systemTime [clock seconds] 	
												puts $outfile "Date Installed: [clock format $systemTime -format %D] - [clock format $systemTime -format %H:%M:%S]"							
												close $outfile
													
													
												#Copia o descritor temporário renomeado e com a data de instalação para a pasta de externals	
												file copy -force -- "$finalname/Descriptor.txt" $dir 
												
												
												#Copia a pasta temporária contendo apenas o arquivo de plugin para a pasta externals
												#Deleta todos os arquivos temporários
												file copy -force -- "$finalname" $dir
												#file delete -force -- "$finalname-Descriptor.txt"
												file delete -force -- "$finalname"
												#file delete -force -- "$finalname-Documentation.txt"
												
												#Mensagem de sucesso e a tela é destruída	
												
												tk_messageBox -message "External installed sucessfully!" -type ok
											
											
											
										} else {
											tk_messageBox -message "Package $fils already installed!" -type ok
										}
										
									}
								}
								
								
							}
					place .t.b2 -x 140 -y 320		
}
proc Desinstalar { } {
	destroy .t
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Install Package"
	wm resizable .t 0 0 
	.t configure -height 400
	.t configure -width  800
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .

					frame .t.frm
					labelframe .t.frm.lbf -text "Select the External(s) you wish to uninstall" -padx 0 -width 57
					tablelist::tablelist .t.frm.lbf.mlb -selectmode multiple -columns {0 "External"} \
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
					
					set dir "~/pd-externals"
					
					proc findFiles { basedir pattern } {
							# Fix the directory name, this ensures the directory name is in the
							# native format for the platform and contains a final directory seperator
							set basedir [string trimright [file join [file normalize $basedir] { }]]
							set fileList {}
							# Look in the current directory for matching files, -type {f r}
							# means ony readable normal files are looked at, -nocomplain stops
							# an error being thrown if the returned list is empty
							foreach fileName [glob -nocomplain -type {f r} -path $basedir $pattern] {
								lappend fileList $fileName
							}
							# Now look for any sub direcories in the current directory
							foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
								# Recusively call the routine on the sub directory and append any
								# new files to the results
								set subDirList [findFiles $dirName $pattern]
								if { [llength $subDirList] > 0 } {
									foreach subDirFile $subDirList {
										lappend fileList $subDirFile
									}
								}
							}
							return $fileList
					}
					
					set fileser [ join [ findFiles $dir "Descriptor.txt" ] \n ]
								
				
						foreach fils $fileser {
								
								regsub -all "/Descriptor.txt" $fils {} filer
							
								set file [ file tail $filer ]
								
								.t.frm.lbf.mlb insert end [list "$file"]
						}
															
										
					button .t.b1 -text "Cancel" \
							-command {Cancelar .t}
					place .t.b1 -x 40 -y 320
					
					button .t.b2 -text "Uninstall External(s)" \
							-command {
								
								set sele [.t.frm.lbf.mlb curselection]
										
										if { $sele ne "" } {
											foreach fils $sele {
												set contsele [.t.frm.lbf.mlb get $fils]
											
								
												file delete -force -- "~/pd-externals/$contsele"
												
											}
											.t.frm.lbf.mlb delete $sele 
										} else {
										 tk_messageBox -message "Please Select the Package(s)!" -type ok
								}
								
								
							}
					place .t.b2 -x 140 -y 320
					
	
}

#Função para criar pacotes
proc Criar {} {
	destroy .t
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
							
							if {![file isdirectory "~/pd-externals/pdpk_packages"]} {			  
								file mkdir "~/pd-externals/pdpk_packages"
							}
							set dir "~/pd-externals/pdpk_packages"
								
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
proc Remover { } {
	destroy .t
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Install Package"
	wm resizable .t 0 0 
	.t configure -height 400
	.t configure -width  800
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .

					frame .t.frm
					labelframe .t.frm.lbf -text "Select the Package(s) you wish to Remove" -padx 0 -width 57
					tablelist::tablelist .t.frm.lbf.mlb -selectmode multiple -columns {0 "External"} \
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
					
					set dir "~/pd-externals/pdpk_packages"
					
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
								
								#regsub -all "/Descriptor.txt" $fils {} filer
							
								set file [ file tail $fils ]
								
								.t.frm.lbf.mlb insert end [list "$file"]
						}
					
					button .t.b1 -text "Cancel" \
							-command {Cancelar .t}
					place .t.b1 -x 40 -y 320
					
					button .t.b2 -text "Remove Package(s)" \
							-command {
								
								set sele [.t.frm.lbf.mlb curselection]
										
										if { $sele ne "" } {
											foreach fils $sele {
												set contsele [.t.frm.lbf.mlb get $fils]
											
								
												file delete -force -- "~/pd-externals/pdpk_packages/$contsele"
												
											}
											.t.frm.lbf.mlb delete $sele 
										} else {
										 tk_messageBox -message "Please Select the Package(s)!" -type ok
								}
								
								
							}
					place .t.b2 -x 140 -y 320
						
	
	
}
proc Cancelar { .t } {
	destroy .t
	
}

proc RepType {} {
	
	destroy .t
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Repository Type"
	wm resizable .t 0 0 
	.t configure -height 200
	.t configure -width  400
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .
	
	labelframe .t.l99 -text "What type of repository do you wish to create?"
	#place .t.l99 -x 70 -y 5
	
	button .t.b -text "Main Repository" -width 50 -height 5\
			-command { MainRep }
	#place .t.b -x 20 -y 30

	button .t.b1 -text "Specific Repository" -width 50 -height 5\
			-command { SpeRep }
	#place .t.b1 -x 140 -y 120
	button .t.b2 -text "Cancel" -width 50 -height 5\
			-command { Cancelar .t }
	
	
	pack .t.b .t.b1 .t.b2 -in .t.l99 -pady 5
	pack .t.l99 -in .t -ipadx 20 -ipady 5 -padx 10 -pady 5
}

proc MainRep { } {
	destroy .t
	set dir "~/pd-externals"
	file delete -force -- "$dir/Descriptor.txt"
	
	if { ![file exist "$dir/RepositoryDescriptor.txt"] } {
						set root "~/"
						set owner [file tail $root]

						set RepDes "$dir/RepositoryDescriptor.txt"
						set outfile [open "$dir/RepositoryDescriptor.txt" w]
						set systemTime [clock seconds]
									
						puts $outfile "Owner: $owner "
						puts $outfile "Date Created: [clock format $systemTime -format %D] - [clock format $systemTime -format %H:%M:%S] "
					
						close $outfile
	} else {
		set answer [tk_messageBox -message "There is already a Main Repository\nWould you like to update it?" -type yesno -icon question]
				switch -- $answer {
							yes {
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
							no exit
						}
	}
		set outfile [open "$dir/RepositoryDescriptor.txt" a+]
			set systemTime [clock seconds]						
			puts $outfile "Last Modified: [clock format $systemTime -format %D] - [clock format $systemTime -format %H:%M:%S] \n"
		close $outfile
		
		proc findFiles { basedir pattern } {
				# Fix the directory name, this ensures the directory name is in the
				# native format for the platform and contains a final directory seperator
				set basedir [string trimright [file join [file normalize $basedir] { }]]
				set fileList {}
				# Look in the current directory for matching files, -type {f r}
				# means ony readable normal files are looked at, -nocomplain stops
				# an error being thrown if the returned list is empty
				foreach fileName [glob -nocomplain -type {f r} -path $basedir $pattern] {
					lappend fileList $fileName
				}
				# Now look for any sub direcories in the current directory
				foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
					# Recusively call the routine on the sub directory and append any
					# new files to the results
					set subDirList [findFiles $dirName $pattern]
					if { [llength $subDirList] > 0 } {
						foreach subDirFile $subDirList {
							lappend fileList $subDirFile
						}
					}
				}
				return $fileList
		}
		
		set fileser [ join [ findFiles $dir "Descriptor.txt" ] \n ]
			foreach fils $fileser {
				
				regsub -all "/Descriptor.txt" $fils {.pdpk} filer
				set filename [file tail $filer]
				
				file delete -force -- "Descriptor.txt"	
				set f [open $fils]
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
						if {[regexp {Author:\s+(.*)} $line all author]} {
									regsub -all {\s} $author {_} author
						}
						if {[regexp {License:\s+(.*)} $line all license]} {
									regsub -all {\s} $license {_} license
						}
						if {[regexp {Supported Architectures:\s+(.*)} $line all arch]} {
						
						}
						
					}					
				close $f
				#file delete -force -- "Descriptor.txt"
				set outfile [open "$dir/RepositoryDescriptor.txt" a+]
						puts $outfile "$filename \t/$name \t/$version \t/$author \t/$arch \t/$summary \t/$type \t/$license \t"
				
				close $outfile
				
				
			}
			tk_messageBox -message "Repository Descriptor ready! \nPlease upload to a personal host" -type ok
					
					
	
}





proc SpeRep { } {
	destroy .t
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Repository Type"
	wm resizable .t 0 0 
	.t configure -height 500
	.t configure -width  500
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .
	
				frame .t.frm
				labelframe .t.frm.lbf -text "Select the Package(s)" -padx 0 -width 57
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
										{{Pure Data package files}       {.pdpk}        }
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

proc Download { } {
	destroy .t
	set default "http...."
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Download Package"
	wm resizable .t 0 0 
	.t configure -height 60
	.t configure -width  580
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .
	
	label .t.lbl1 -text "Enter the repository URL"
	place .t.lbl1 -x 20 -y 5
	
	entry .t.url -width 50 
	place .t.url -x 10 -y 25
	
	button .t.bcancel -text "Cancel" -width 5 -height 1 \
			-command {Cancelar .t}
	place .t.bcancel -x 490 -y 20
	
	button .t.b -text "Ok" \
			-command {
				set url [.t.url get]
				set rep [Ver_Rep $url]
				if { $rep } {
				
				.t configure -height 600
				.t configure -width 500
				place .t.bcancel -x 10 -y 500
				.t.bcancel configure -width 17 -height 2
				
				} else {
					tk_messageBox -message "This URL is not a pdpk repository!" -type ok
					.t configure -height 60
					.t configure -width 580
					place .t.bcancel -x 490 -y 20
					.t.bcancel configure -width 5 -height 1
				}
			}
		place .t.b -x 430 -y 20
	
	entry .t.esearch -width 40
	place  .t.esearch -x 10 -y 65
	
	labelframe .t.lbl -text "Search" -padx 0 
	radiobutton .t.r1 -text "Name" -variable reptype -value 1 
	radiobutton .t.r2 -text "Archtecture" -variable reptype -value 3
	radiobutton .t.r3 -text "Type" -variable reptype -value 5
	radiobutton .t.r4 -text "Summary" -variable reptype -value 4 
	pack .t.r1 .t.r2 .t.r3  .t.r4  -in .t.lbl -anchor w	
	place .t.lbl -x 370 -y 65
	
	.t.r1 select
	

	button .t.b1 -text "Search" -width 37 -height 4 \
			-command {
				set term [.t.esearch get]
				destroy .t.frm
				destroy .t.frm.lbf.mlb
				
					puts " URL: $url"
				
					frame .t.frm
					labelframe .t.frm.lbf -text "Search Results for: $term" -padx 0 -width 57
					tablelist::tablelist .t.frm.lbf.mlb -selectmode multiple -columns {0 "File" 0 "Name" 0 "Version" 0 "Archtectures" 0 "Summary" 0 "Type"} \
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

					place .t.frm -x 10 -y 185
				 
					
 				
				
				set results [ join [ search_for $term $reptype ] \n ] 

				}
								
	place .t.b1 -x 10 -y 90
	
proc search_for {term reptype} {
    set searchresults [list]

set cont 0
set flag 0
	set f [open "RepDes/RepositoryDescriptor.txt"]
		while {[gets $f line] != -1} {
			
			if {$cont < 4} {
				incr cont
			} else {	
							
				set search [lindex $line $reptype]
				
					if {[regexp -nocase "$term" $search all linha ]} {
						
						#puts "linha: $linha"				
						#puts "all: $all"
						#puts "line: $line"			
						#lappend searchresults [lindex $line 4]
						
						
						set name [lindex $line 1]
						set version [lindex $line 2]
						set arch [lindex $line 3]
						set summary [lindex $line 4]
						set type [lindex $line 5]
						
						regsub -all {_} $name { } name
						regsub -all {_} $version { } version
						regsub -all {_} $arch { } arch
						regsub -all {_} $summary { } summary
						regsub -all {_} $type { } type
						
						regsub -all {/} $name {} name
						regsub -all {/} $version {} version
						regsub -all {/} $arch {} arch
						regsub -all {/} $summary {} summary
						regsub -all {/} $type {} type
									
					
						.t.frm.lbf.mlb insert end [list "[lindex $line 0]" "$name" "$version" "$arch" "$summary" "$type" ]
						set flag 1
						#.t.mlb insert end [list "1" "2" "3" "4" "5" "6" ]
						
						#lappend searchresults $line
					}
				
			}
		}
		
	close $f
	#puts $searchresults
	destroy .t.b2
	if { $flag ne 0 } {
		button .t.b2 -text "Download Selected" -width 17 -height 2 \
				-command {
							
							set sele [.t.frm.lbf.mlb curselection]
									
									if { $sele ne "" } {
										foreach fils $sele {
											
											set contsele [.t.frm.lbf.mlb get $fils]
											set file [lindex $contsele 0]
											puts "FILE: $file"
											if { $file ne "" } {
												getPage $url $file 
											}
										}
									} else {
										tk_messageBox -message "Please select a Package" -type ok
									}

						}
									
		place .t.b2 -x 200 -y 500
		
	}
	set flag 0
    return $searchresults
}
	
}

proc getPage { url outputfilename } {
	 puts "FUNÇÃO GETPAGE"
	 puts "URL: $url"
	 puts "filename: $outputfilename"
     set f [open "~/pd-externals/pdpk_packages/$outputfilename" w]
    set status ""
    set errorstatus ""
    fconfigure $f -translation binary
    set httpresult [http::geturl "$url/$outputfilename" -binary true -channel $f]
    set status [::http::status $httpresult]
    set errorstatus [::http::error $httpresult]
    flush $f
    close $f
    http::cleanup $httpresult
    
    if { $status eq "ok" } {
		tk_messageBox -message "Package downloaded sucessfully!" -type ok
	}
    
    return [list $status $errorstatus ]
  }

proc Ver_Rep { url } {
	
	set status ""
    set errorstatus ""
    
   
	http::register https 443 [list ::tls::socket -tls1 1]   ;# "-tls1 1" is required since [POODLE]
  
	set token [http::geturl "$url/RepositoryDescriptor.txt"]
	
	set status [::http::status $token]
    set errorstatus [::http::ncode $token]
    puts "status: $status"
    puts "error: $errorstatus"
    
    
    if { $errorstatus eq 200 } {
		
		set f [open "RepDes/RepositoryDescriptor.txt" w]
		set status ""
		set errorstatus ""
		fconfigure $f -translation binary
		set httpresult [http::geturl "$url/RepositoryDescriptor.txt" -binary true -channel $f]
		flush $f
		close $f
		http::cleanup $httpresult
		return true		
	} else {
		return false
	}
    #puts $contents
}

proc Atualizar { } {
	destroy .t
	set default "http...."
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Download Package"
	wm resizable .t 0 0 
	.t configure -height 60
	.t configure -width  580
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .
	
	label .t.lbl1 -text "Enter the repository URL"
	place .t.lbl1 -x 20 -y 5
	
	entry .t.url -width 50 
	place .t.url -x 10 -y 25
	
	button .t.bcancel -text "Cancel" -width 5 -height 1 \
			-command {Cancelar .t}
	place .t.bcancel -x 490 -y 20
	
	button .t.b -text "Ok" \
			-command {
				set url [.t.url get]
				set rep [Ver_Rep $url]
				if { $rep } {
				
				.t configure -height 350
				.t configure -width 500
				place .t.bcancel -x 10 -y 300
				.t.bcancel configure -width 17 -height 2
				set results [ join [ search_for ] \n ]
				
				if { $results eq 1 } {
					place .t.bdown -x 200 -y 300
				}
				
				} else {
					tk_messageBox -message "This URL is not a pdpk repository!" -type ok
					.t configure -height 60
					.t configure -width 580
					place .t.bcancel -x 490 -y 20
					.t.bcancel configure -width 5 -height 1
				}
			}
					place .t.b -x 430 -y 20
	
					frame .t.frm
					labelframe .t.frm.lbf -text "New Versions" -padx 0 -width 57
					tablelist::tablelist .t.frm.lbf.mlb -selectmode multiple -columns {0 "File" 0 "Name" 0 "Version" 0 "Archtectures" 0 "Summary" 0 "Type"} \
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

					place .t.frm -x 10 -y 65
					
					button .t.bdown -text "Update Selected" -width 17 -height 2 \
						-command {
									
									set sele [.t.frm.lbf.mlb curselection]
									
									if { $sele ne "" } {
									foreach fils $sele {
										
										set contsele [.t.frm.lbf.mlb get $fils]
										set file [lindex $contsele 0]
										puts "FILE: $file"
										if { $file ne "" } {
											getPage $url $file 
										}
									}
									} else {
										tk_messageBox -message "Please select a Package" -type ok
									}
								}
									
		
					
					
					
proc search_for { } {
    set searchresults [list]

set cont 0

set flag 0
	set f [open "RepDes/RepositoryDescriptor.txt"]
		while {[gets $f line] != -1} {
			
			if {$cont < 4} {
				incr cont
			} else {	
							
				set search [lindex $line 1]
				set filename [file tail $search]
		
				
				set search [lindex $line 4]
				set arch [file tail $search]

				set cont1 0
				set f1 [open "~/pd-externals/RepositoryDescriptor.txt"]
					while {[gets $f1 line1] != -1} {
					
						if {$cont1 < 4} {
							incr cont1
						} else {
							
							set search1 [lindex $line1 1]
							set filename1 [file tail $search1]
						
							
							set search1 [lindex $line1 4]
							set arch1 [file tail $search1]
					
							
							if { $filename eq $filename1 } {
								if { $arch eq $arch1 } {
									set version [lindex $line 2]
									set version1 [lindex $line1 2]
									
									if { $version1 < $version } {
										
										set name [lindex $line 1]
										set version [lindex $line 2]
										set arch [lindex $line 3]
										set summary [lindex $line 4]
										set type [lindex $line 5]
										
										regsub -all {_} $name { } name
										regsub -all {_} $version { } version
										regsub -all {_} $arch { } arch
										regsub -all {_} $summary { } summary
										regsub -all {_} $type { } type
										
										regsub -all {/} $name {} name
										regsub -all {/} $version {} version
										regsub -all {/} $arch {} arch
										regsub -all {/} $summary {} summary
										regsub -all {/} $type {} type
													
									
										.t.frm.lbf.mlb insert end [list "[lindex $line 0]" "$name" "$version" "$arch" "$summary" "$type" ]
										set flag 1
									} 
								}
							}
						}
					}
				close $f1
				
				
				
			}		
		}
		
	close $f
	#puts $searchresults
	
    return $flag
}				
	
}


