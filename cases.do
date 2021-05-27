
******************************************************
** Project: Development of COVID-19 Cases in Tawian **
** Author: Wen-Chin Wu, Academia Sinica             **
** Date: 20210526                                   **
******************************************************

// Read Data //
import excel "cases.xlsx", sheet("cases") firstrow clear

browse

lab var date "Date"
lab var day "Day"
lab var reported "Original reported cases"
lab var noback "Number of cases if no backlog"
lab var b0522 "Updated cases repoted on 0522"
lab var b0523 "Updated cases repoted on 0523"
lab var b0524 "Updated cases repoted on 0524"
lab var b0525 "Updated cases repoted on 0525"
lab var b0526 "Updated cases repoted on 0526"

// Set TSCS data //

gen x = 1
gen y = 1
destring day, force replace

lab var x "Use for xtset only" 
lab var y "Use to indicate the position of reported number (reported)"

xtset x day

// Calculate 7-day moving average //

asrol noback, wind(day 7) stat(mean) min(1)   // 7-average line if there is no backlog //
asrol b0526, wind(day 7) stat(mean) min(1)   // b0526 needs to be replaced with new reported data //

// Draw the graph //

twoway bar reported day, bargap(10) color(ebblue%90) barw(0.7) || ///
   	   rbar noback reported day, color(gs12) barw(0.7) lcolor(dkgreen*0.8%90) lwidth(0.5) || ///
       rbar reported b0522 day,color(dkorange) barw(0.7)  ||  ///
	   rbar b0522 b0523  day, barw(0.7) color(dkorange%90) ||  ///
	   rbar b0523 b0524  day, barw(0.7) color(dkorange%80) || ///
	   rbar b0524 b0525  day, barw(0.7) color(dkorange%70) || ///
	   rbar b0525 b0526  day, barw(0.7) color(dkorange%60) ||  ///
	   scatter b0526 day if day > 6 & day < 19, mlabel(b0526) ///
	           mlabposition(12) ms(none) mlabcolor(dkorange) mlabsize(vsmall) || ///
	   scatter y day, mlabel(reported) mlabposition(12) ms(none) mlabcolor(dknavy) ///
	           mlabsize(vsmall) ||	  ///
	   line mean7_b0526 day, lcolor(red%70) lwidth(0.5) lpattern(solid) || ///
	   line mean7_noback day, lcolor(black%70) lwidth(0.5) lpattern(dash)  ///
	   scheme(cleanplots) xtitle("") ///
	   legend(position(6) row(2)   ///
	         order(1 "當日公布病例" 3 "當日校正後病例" 2 "當日校正回歸案件總數" ///
	               11 "七日平均線（使用未校正回歸資料）"  ///
				   10 "七日平均線（使用校正回歸資料）")) ///
	   xlabel(1 "5/8" 2 "5/9" 3 "5/10" 4 "5/11" 5 "5/12" 6 "5/13" 7 "5/14" ///
	          8 "5/15" 9  "5/16" 10 "5/17" 11 "5/18" 12 "5/19" 13 "5/20" ///
			  14 "5/21" 15 "5/22" 16 "5/23"  ///
			  17 "5/24" 18 "5/25" 19 "5/26") ///
	   ytitle("病例數目") ///
	   note("註：依照中央流行疫情指揮中心5月26日發布資料繪製。")

graph export update_0526.png, width(800) replace

// The end, but to be updated:
// Procedure of Updating:
// 1. Add a column to indicate the latest number of cases for each day (e.g., b0527) //
// 2. Calculate the total number of cases "BEFORE" backlog //
// 3. Add "rbar" "yesterday" "today" day to crease a new add-on for each day. 
// 4. Replace "yesterday" with "today" for 7-day moving average & scatter //
////////////////////////////////////////////////////////////////////////////

