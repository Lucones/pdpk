 package require Tk
 package require tablelist 
 package require http
 package require tls
	set ::reptype 0
	set default "http...."
	tk::toplevel .t
	set oldtitle [wm title .t]
	wm title .t "Download Package"
	wm resizable .t 0 0 
	.t configure -height 60
	.t configure -width  500
	update
	set x [expr {([winfo screenwidth .t]-[winfo width .t])/2}]
	set y [expr {([winfo screenheight .t]-[winfo height .t])/2}]
	wm geometry  .t +$x+$y
	wm transient .t .
	
	label .t.lbl1 -text "Enter the repository URL"
	place .t.lbl1 -x 20 -y 5
	
	entry .t.url -width 50 
	place .t.url -x 10 -y 25
	
	button .t.b -text "Ok" \
			-command {
				set url [.t.url get]
				set rep [Ver_Rep $url]
				if { $rep } {
				
				.t configure -height 600
				
				} else {
					tk_messageBox -message "This URL is not a pdpk repository!" -type ok
					.t configure -height 60
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
	
	set i 2
	set x 80
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
				 
					proc blerg {  } {
						puts aehooooo
					}
 				
				#pack .t.mlb.sb .t.mlb 
				
							
				#pack .t.mlb  -in .t.lbf -anchor w
				
				#place .t.lbf -x 10 -y 125
				
				
				set results [ join [ search_for $term $reptype ] \n ] 
				
				
				#pack .t.mlb -fill both -expand 1 -side top
				
				
				
					

				}
								
	place .t.b1 -x 10 -y 90
	
	

 
 set url "http://dcomp.ufsj.edu.br/~fls/compmus/AtividadeLab.pdf"
 set outputfilename [file tail $url]
 #set term "dsfsdf"
 
 
 
 proc search_for {term reptype} {
    set searchresults [list]
    
 
    #set token [http::geturl "http://puredata.info/search_rss?SearchableText=$term+externals.zip&portal_type%3Alist=IAEMFile&portal_type%3Alist=PSCfile"]
    #set token [http::geturl "$url/RepositoryDescriptor.txt"]
    #set contents [http::data $token]
#puts $searchtype
#puts $term

set cont 0
set flag 0
	set f [open "RepDes/RepositoryDescriptor.txt"]
		while {[gets $f line] != -1} {
			
			if {$cont < 3} {
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
							puts "sele: $sele"
							foreach fils $sele {
								puts "fils: $fils"
								set contsele [.t.frm.lbf.mlb get $fils]
								set file [lindex $contsele 0]
								if { $file ne "" } {
									puts getPage{ $url $file }
								}
							}
							
							
							
									
									
														
							
						}
									
		place .t.b2 -x 10 -y 500
	}
	set flag 0
    return $searchresults
}


proc getPage { url outputfilename } {
	  
     set f [open $outputfilename w]
    set status ""
    set errorstatus ""
    fconfigure $f -translation binary
    set httpresult [http::geturl $url -binary true -channel $f]
    set status [::http::status $httpresult]
    set errorstatus [::http::error $httpresult]
    flush $f
    close $f
    http::cleanup $httpresult
    return [list $status $errorstatus ]
  }

#getPage $url $outputfilename
proc Ver_Rep { url } {
	
	set status ""
    set errorstatus ""
    
	set token [http::geturl "$url/RepositoryDescriptor.txt"]
	
	set status [::http::status $token]
    set errorstatus [::http::code $token]
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
