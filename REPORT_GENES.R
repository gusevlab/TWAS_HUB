tbl.panels = read.table("panels.par",as.is=T,head=T,sep='\t')
N.models = nrow(tbl.panels)
df.panels = data.frame( "n"=tbl.panels$N , "study"=tbl.panels$STUDY , "tissue"=tbl.panels$TISSUE , "num.hits" = rep(0,N.models) , "num.traits" = rep(0,N.models) , row.names=tbl.panels$ID )

tbl.models.pos = read.table("all.models.par",as.is=T,head=T)
m = match( tbl.models.pos$PANEL , tbl.panels$PANEL )
tbl.models.pos$PANEL = paste( tbl.panels$STUDY , " | " , tbl.panels$TISSUE , sep='' )[ m ] 

# ---- PRINT TRAIT INDEX
tbl.traits = read.table("traits.par",as.is=T,head=T,sep='\t',quote="")
N.traits = nrow(tbl.traits)
df.traits = data.frame( "type" = tbl.traits$TYPE , "name" = tbl.traits$NAME , "n" = tbl.traits$N , "num.loci" = rep(NA,N.traits) , "num.joint.genes" = rep(NA,N.traits) , "num.total.genes" = rep(NA,N.traits) , "ref" = tbl.traits$REF , "year" = tbl.traits$YEAR , row.names=tbl.traits$ID )
df.traits$link = paste( "[" , df.traits$name , "](/traits/" , rownames(df.traits) , ")" , sep='' )

traits.nfo = read.table("traits.par.nfo",as.is=T,head=T)
m = match( rownames(df.traits) , traits.nfo[,1] )
traits.nfo = traits.nfo[m,]
df.traits$num.loci = traits.nfo$NUM.LOCI
df.traits$num.joint.genes = traits.nfo$NUM.JOINT.GENES
df.traits$num.total.genes = traits.nfo$NUM.GENES

fout = "traits.md"
cat( "---","title: Traits","permalink: traits/","layout: traits","---\n",sep='\n',file=fout)
cat( "# *",nrow(df.traits),"* traits &middot; *",formatC(sum(df.traits$num.loci), format = "f", big.mark = ",", drop0trailing = TRUE),"* associated loci &middot; *", formatC(sum(df.traits$num.total.genes), format = "f", big.mark = ",", drop0trailing = TRUE),"*  associated genes\n\n",sep='',file=fout,append=T)
cat( "| Type | Trait | N | # loci | # indep genes | # total genes | Ref. | Year |","| --- |",sep='\n',file=fout,append=T)
write.table(df.traits[,c("type","link","n","num.loci","num.joint.genes","num.total.genes","ref","year")],quote=F,row.names=F,col.names=F,sep=' | ',file=fout,append=T)

fout = "models.md"
cat( "---","title: Models","permalink: models/","layout: models","---\n",sep='\n',file=fout)
cat( "# Models \n\n",sep='',file=fout,append=T)

cat( "| Study | Tissue | N |","| --- |",sep='\n',file=fout,append=T)
write.table(df.panels[,c("study","tissue","n")],quote=F,row.names=F,col.names=F,sep=' | ',file=fout,append=T)
# ----

# iterate and make each gene file
uni.genes = sort(unique( tbl.models.pos$ID ))

df.genes = data.frame( "gene" = uni.genes , "n.models" = rep(0,length(uni.genes)) , "n.assoc" = rep(0,length(uni.genes)) )
df.genes$link = paste( '*' , paste( "[" , df.genes$gene , "]({{ site.baseurl }}genes/" , df.genes$gene , ")" , sep='' ) , '*' , sep='' )

# df.json = df.genes[,c("gene","n.models","n.assoc")]
# df.json$gene = paste( "<em><a href=\"/genes/",df.json$gene,"\">",df.genes$gene,"</a></em>",sep='' )
# names(df.json) = c("gene","n_models","n_assoc")
# library('RJSONIO')
# cat( toJSON(unname(split(df.json, 1:nrow(df.json)))) , file="genes.json" )

for ( i in 1:length(uni.genes) ) {
	fout = paste("genes/",uni.genes[i],".md",sep='')
	cat( "---\n","title: ",uni.genes[i],"\npermalink: genes/",uni.genes[i],"/ \nlayout: gene\n","---\n\n",sep='',file=fout )
	cat( "## [Hub]({{ site.baseurl }}) : [Genes]({{ site.baseurl }}genes)\n\n" , file=fout , append=T )
	cat( '# ' , uni.genes[i] , '\n' , sep='',file=fout,append=T )
	
	# WGT	ID	CHR	P0	P1	ID	NSNPS	HSQ	HSQ.SE	HSQ.PV	TOP1.R2	BLUP.R2	ENET.R2	BSLMM.R2	LASSO.R2	TOP1.PV	BLUP.PV	ENET.PV	BSLMM.PV	LASSO.PV
	cat( '\n### Models\n\n' , sep='',file=fout,append=T)
	cat( '| # | panel | tissue | h2 | h2 se | h2 P | eQTL R2 | BLUP R2 | ENET R2 | BSLMM R2 | LASSO R2 | eQTL P | BLUP P | ENET P | BSLMM P | LASSO P |\n| --- |\n' , sep='',file=fout,append=T)
	cur.models = tbl.models.pos[ tbl.models.pos$ID == uni.genes[i] , ]
	cur.models$NUM = 1:nrow(cur.models)
	df.genes$n.models[i] = df.genes$n.models[i] + nrow(cur.models)
	write.table(format(cur.models[,c("NUM","PANEL","HSQ","HSQ.SE","HSQ.PV","TOP1.R2","BLUP.R2","ENET.R2","BSLMM.R2","LASSO.R2","TOP1.PV","BLUP.PV","ENET.PV","BSLMM.PV","LASSO.PV")],digits=3),quote=F,row.names=F,col.names=F,sep=' | ',file=fout,append=T)
	cat( '{: #models}\n\n' , file=fout,append=T)

	cat("\n### Trait associations\n\n | Trait | Avg chi2 ratio | Avg chi2 | Max chi2 | ",paste(1:df.genes$n.models[i],collapse=" | "),"| \n | --- |\n" , sep='', file=paste("genes/",uni.genes[i],".md",sep='') , append=T )
	
	if ( i %% 100 == 0 ) cat(i,'\n')
}

# iterate over each trait and count the number of significant genes
for ( i in 1:N.traits ) {
	system( paste( 'bash APPEND_GENES.sh ',tbl.traits$OUTPUT[i]," \"",df.traits$link[i],"\" ",traits.nfo$AVG.CHISQ[i],"\n" ,sep='' ) )
	cat( i , '\n' )
}

for ( i in 1:length(uni.genes) ) {
	cat("{: #assoc}\n", file=paste("genes/",uni.genes[i],".md",sep='') , append=T )	
}

# ---- PRINT GENE INDEX
fout = "genes.md"
cat( "---","title: Genes","permalink: genes/","layout: genes","---\n",sep='\n',file=fout)
cat( "# *",formatC(nrow(df.genes), format = "f", big.mark = ",", drop0trailing = TRUE),"* genes &middot; *",formatC(sum(df.genes$n.models), format = "f", big.mark = ",", drop0trailing = TRUE),"* models\n\n",sep='',file=fout,append=T)

cat( '### Analyzed genes\n\n' ,sep='',file=fout,append=T)
cat( "| Gene | # models | # associations |\n","| --- |\n",sep='',file=fout,append=T)
write.table(df.genes[,c("link","n.models","n.assoc")],quote=F,row.names=F,col.names=F,sep=' | ',file=fout,append=T)
cat( '{: #genes}\n' ,file=fout,append=T)
# ----
