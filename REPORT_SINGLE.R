arg = commandArgs(trailingOnly=T)
CUR.TRAIT = as.numeric(arg[1])

tbl.traits = read.table("traits.par",as.is=T,head=T,sep='\t',quote="")
N.traits = nrow(tbl.traits)
df.traits = data.frame( "name" = tbl.traits$NAME , "n" = tbl.traits$N , "num.genes" = rep(NA,N.traits) , "num.models" = rep(NA,N.traits) , "ref" = tbl.traits$REF , "year" = tbl.traits$YEAR , row.names=tbl.traits$ID )
df.traits$link = paste( "[" , df.traits$name , "]({{ site.baseurl }}traits/" , rownames(df.traits) , ")" , sep='' )

tbl.panels = read.table("panels.par",as.is=T,head=T,sep='\t')
N.models = nrow(tbl.panels)
df.panels = data.frame( "study"=tbl.panels$STUDY , "tissue"=tbl.panels$TISSUE , "num.hits" = rep(0,N.models) , "num.traits" = rep(0,N.models) , row.names=tbl.panels$ID )

tbl.models.pos = read.table("all.models.par",as.is=T,head=T)
m = match( tbl.models.pos$PANEL , tbl.panels$PANEL )
tbl.models.pos$PANEL = paste( tbl.panels$STUDY , " | " , tbl.panels$TISSUE , sep='' )[ m ] 

traits.nfo = read.table("traits.par.nfo",as.is=T,head=T)
m = match( rownames(df.traits) , traits.nfo$ID )
traits.nfo = traits.nfo[m,]

# iterate and make each gene file
uni.genes = sort(unique( tbl.models.pos$ID ))
df.genes = data.frame( "gene" = uni.genes , "n.models" = rep(0,length(uni.genes)) , "n.assoc" = rep(0,length(uni.genes)) )
df.genes$link = paste( '*' , paste( "[" , df.genes$gene , "]({{ site.baseurl }}genes/" , df.genes$gene , ")" , sep='' ) , '*' , sep='' )

# iterate over each trait and count the number of significant genes
i = CUR.TRAIT

cur = read.table( tbl.traits$OUTPUT[i] , as.is=T , head=T , sep='\t' )
n = nrow(cur)
top.models = which(as.numeric(cur$TWAS.P) < 0.05/n)
n.top = length(top.models)

top.genes = unique(cur$ID[ top.models ])

df.traits$num.models[ i ] = length(top.models)
df.traits$num.genes[ i ] = length(top.genes)

df.cur.models = data.frame( "study"=tbl.panels$STUDY , "tissue"=tbl.panels$TISSUE , "num.hits" = rep(0,N.models) , "pct.hits" = rep(0,N.models) , "avg.chisq" = rep(NA,N.models) , row.names=tbl.panels$ID )
for ( m in 1:N.models ) {
	keep = cur$PANEL == tbl.panels$PANEL[m]
	df.cur.models$avg.chisq[m] = mean( as.numeric(cur$TWAS.Z[ keep ])^2 , na.rm=T )
	df.cur.models$num.hits[m] = sum( as.numeric(cur$TWAS.P[ keep ]) < 0.05/n , na.rm=T )
	df.cur.models$pct.hits[m] = 100*mean( as.numeric(cur$TWAS.P[ keep ]) < 0.05/n , na.rm=T )
}

# ---- PRINT DISEASE PAGE

fout = paste("traits/",tbl.traits$ID[i],".md",sep='')
system( paste("mkdir --parents traits/",tbl.traits$ID[i],sep='') )

cat( "---\n","title: \"",tbl.traits$NAME[i],"\"\npermalink: traits/",tbl.traits$ID[i],"/\nlayout: trait\n","---\n\n",sep='',file=fout)
cat( "## [Hub]({{ site.baseurl }}) : [Traits]({{ site.baseurl }}traits/) : \n\n" , file=fout , append=T )
cat( '# ' , tbl.traits$NAME[i] , '\n' , sep='',file=fout,append=T)
cat( '`' , df.traits$num.models[i] , " significantly associated models · " , df.traits$num.genes[i] , " unique genes`.\n\n" , sep='' , file=fout,append=T)

# ---- Get clumped and conditional loci
if ( file.info( paste( tbl.traits$OUTPUT[i] , ".post.report",sep='') )$size  != 0 ) {
cur.clumps = read.table( paste( tbl.traits$OUTPUT[i] , ".post.report",sep='') , as.is=T , head=T )

cat( '\n### Significant Loci\n\n' , sep='',file=fout,append=T)
cat( '| # | chr | p0 | p1 | # assoc genes | # joint genes | best TWAS P | best SNP P | cond SNP P | % var exp | joint genes |\n| --- |\n' , sep='',file=fout,append=T)
cur.clumps$VAR.EXP = round( cur.clumps$VAR.EXP * 100 , 0 )
cur.clumps = cur.clumps[ order(cur.clumps$CHR,cur.clumps$P0) , ]
cur.clumps.files = cur.clumps$FILE
cur.clumps$FILE = 1:nrow(cur.clumps)
cur.clumps$FILE = paste( "*[" , cur.clumps$FILE , "]({{ site.baseurl }}traits/" , rownames(df.traits)[i] , "/" , cur.clumps$FILE , ")*" , sep='' )
cur.clumps$GENES = rep("",nrow(cur.clumps))

# load clumped genes
clump.mod = vector()
for ( ii in 1:nrow(cur.clumps) ) {
	cur.genes.tbl = read.table( paste(cur.clumps.files[ii],".genes",sep='') , head=T , as.is=T )
	cur.genes.tbl$NUM = 1:nrow(cur.genes.tbl)
	cur.genes.tbl$GENE = paste( "*[" , cur.genes.tbl$ID , "]({{ site.baseurl }}genes/" , cur.genes.tbl$ID , ")*" , sep='' )
	
	m = match( cur.genes.tbl$PANEL , tbl.panels$PANEL )
	cur.genes.tbl$STUDY = tbl.panels$STUDY[m]
	cur.genes.tbl$TISSUE = tbl.panels$TISSUE[m]
	cur.genes = sort(unique(cur.genes.tbl$ID[ cur.genes.tbl$JOINT ]))
	cur.genes = paste( '*' , paste( "[" , cur.genes , "]({{ site.baseurl }}genes/" , cur.genes , ")" , sep='' , collapse=' ') , '*' , sep='' )
	cur.clumps$GENES[ii] = cur.genes
	
	clump.mod = unique(c(clump.mod,cur.genes.tbl$FILE[ cur.genes.tbl$JOINT ]))
	
	fout.clump = paste("traits/",tbl.traits$ID[i],"/",ii,".md",sep='')
	cat( "---\n","title: \"",tbl.traits$NAME[i],"\"\npermalink: traits/",tbl.traits$ID[i],"/",ii,"/ \nlayout: locus\n","---\n\n",sep='',file=fout.clump)
	cat( "## [Hub]{{ site.baseurl }}) : [Traits]({{ site.baseurl }}traits) : ",df.traits$link[i] , ' : ' , sep='' , file=fout.clump , append=T )
	if ( ii > 1 ) cat( " [ ← ]({{ site.baseurl }}traits/",tbl.traits$ID[i],"/",(ii-1),") " , sep='' , file=fout.clump , append=T )
	if ( ii < nrow(cur.clumps) ) cat( " [ → ]({{ site.baseurl }}traits/",tbl.traits$ID[i],"/",(ii+1),")" , sep='' , file=fout.clump , append=T )
	
	cat( '\n\n# chr' , cur.clumps$CHR[ii] , ":" , formatC(cur.clumps$P0[ii], format = "f", big.mark = ",", drop0trailing = TRUE) , "-" , formatC(cur.clumps$P1[ii], format = "f", big.mark = ",", drop0trailing = TRUE) , '\n\n' , sep='',file=fout.clump,append=T)
	cat( '`Best TWAS P=',cur.clumps$BEST.TWAS.P[ ii ],' · Best GWAS P=',cur.clumps$BEST.SNP.P[ ii ],' conditioned to ',cur.clumps$COND.SNP.P[ ii ],"`\n\n",sep='',file=fout.clump,append=T)

	system( paste( "cp ",cur.clumps.files[ii],".cond.csv traits/",tbl.traits$ID[i],"/",ii,".cond.csv",sep='') )
	cat( '<script>' , "\n" , 'Plotly.d3.csv("../',ii,'.cond.csv"',', function(data){ processData(data) } );' , "\n" , '</script><div id="graph"></div>' , "\n" ,sep='' , file=fout.clump,append=T)
	# BCAC.1.post.loc_10.cond.csv
	
	cat( '\n### Associated models\n\n' , sep='',file=fout.clump,append=T)
	cat( "| # | Study | Tissue | Gene | h2 | eQTL R2 | model | # weights | model R2 | model R2 P | eQTL GWAS Z | TWAS Z | TWAS P | Top SNP corr | PP3 | PP4 | joint |","| --- |",sep='\n',file=fout.clump,append=T)
	
	cur.genes.tbl$COLOC.PP3 = round( cur.genes.tbl$COLOC.PP3 , 2 )
	cur.genes.tbl$COLOC.PP4 = round( cur.genes.tbl$COLOC.PP4 , 2 )
	cur.genes.tbl$MODELCV.R2 = round( cur.genes.tbl$MODELCV.R2 , 2 )
	cur.genes.tbl$HSQ = round( cur.genes.tbl$HSQ , 2 )
	cur.genes.tbl$EQTL.R2 = round( cur.genes.tbl$EQTL.R2 , 2 )
	
	
write.table(format(cur.genes.tbl[,c("NUM","STUDY","TISSUE","GENE","HSQ","EQTL.R2","MODEL","NWGT","MODELCV.R2","MODELCV.PV","EQTL.GWAS.Z","TWAS.Z","TWAS.P","TOP.SNP.COR","COLOC.PP3","COLOC.PP4","JOINT")],digits=2),quote=F,row.names=F,col.names=F,sep=' | ',file=fout.clump,append=T)
	cat( '{: #models}\n\n' , file=fout.clump,append=T)
}
write.table( format(cur.clumps,digits=2) , quote=F , row.names=F , col.names=F , sep=' | ',file=fout,append=T)
cat( '{: #loci}\n\n' , file=fout,append=T)

# ---- Get pleiotropic loci
n.pleiot = 0
file.top = paste("tmp/",tbl.traits$ID[i],".top",sep='')
write.table( cur$FILE[ !is.na( match( cur$FILE , clump.mod ) ) ] , quote=F , row.names=F , col.names="FILE" , file=file.top ) 

for ( ii in 1:N.traits ) {
	cat( ii , '\n' )
	if ( ii != i ) {
		system( paste( "cat ",file.top," | ~/tools/search ",tbl.traits$OUTPUT[ii]," 2 >",file.top,".tmp" , sep='') )
		other.cur = read.table( paste(file.top,".tmp" , sep='') , as.is=T , head=T , sep='\t' )
		m = match( other.cur$FILE , cur$FILE[ top.models ] )
		other.cur = other.cur[ !is.na(m) , ]
		m = m[!is.na(m)]
		other.this = (cur[ top.models , ])[ m , ]
		keep = which( as.numeric(other.cur$TWAS.P) < 0.05/n.top)
		if ( length(keep) > 0 ) {
			if( length(keep) >= 4 ) {
				tst = cor.test(as.numeric(other.this$TWAS.Z[ keep ]) , as.numeric(other.cur$TWAS.Z[ keep ]) )
			} else {
				tst = data.frame( "est" = 0 , "p.value" = 1 )
			}
			genes = sort(unique(other.this$ID[ keep ]))
			genes.link = paste( '*' , paste( "[" , genes , "]({{ site.baseurl }}genes/" , genes , ")" , sep='' , collapse=' ') , '*' , sep='' )
			num.genes.twas = length(unique(other.this$ID[which( as.numeric(other.cur$TWAS.P) < 0.05/n)]))
			df.tmp = data.frame( "link" = df.traits$link[ii] , "chisq.ratio" = round(mean(as.numeric(other.cur$TWAS.Z)^2,na.rm=T) / traits.nfo$AVG.CHISQ[ii],2) , "num.genes" =  length(unique(other.this$ID[ keep ])) , "num.genes.twas" = num.genes.twas , "pct.genes.twas" = round(100 * num.genes.twas / traits.nfo$NUM.JOINT.GENES[3],1) , "corr" = round(tst$est,2) , "p.val" = tst$p.value , "genes" = genes.link )
			if ( n.pleiot == 0 ) {
				df.pleiot = df.tmp
			} else {
				df.pleiot = rbind(df.pleiot,df.tmp)
			}
			n.pleiot = nrow(df.pleiot)
		}
	}
}

cat( '### Pleiotropic Associations\n\n' , sep='',file=fout,append=T)
if ( n.pleiot != 0 ) {
cat( "| Trait | chisq ratio | # genes<sup>+</sup> | # genes<sup>++</sup> | % genes<sup>++</sup> | corr | corr P | genes |","| --- |",sep='\n',file=fout,append=T)
df.pleiot$pct.genes.twas[ is.na(df.pleiot$pct.genes.twas) ] = 0
write.table(format(df.pleiot,digits=2),quote=F,row.names=F,col.names=F,sep=' | ',file=fout,append=T)
cat( '{: #pleiotropic}\n\n' , file=fout,append=T)
}
	
cat( '### Associations by panel\n\n' ,sep='',file=fout,append=T)
cat( "| study | tissue | # hits | % hits/tests | avg chisq |","| --- |",sep='\n',file=fout,append=T)
write.table(format(df.cur.models,digits=2),quote=F,row.names=F,col.names=F,sep=' | ',file=fout,append=T)
cat( '{: #panels}\n\n' , file=fout,append=T)
}
