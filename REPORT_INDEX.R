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
df.traits$link = paste( "[" , df.traits$name , "]({{ site.baseurl }}traits/" , rownames(df.traits) , ")" , sep='' )

df.traits$data = paste( "[ <i class=\"far fa-file-archive\" aria-hidden=\"true\"></i> ]({{ site.baseurl }}data/" , gsub(".dat","",tbl.traits$OUTPUT) , ".tar.bz2)" , sep='' )

traits.nfo = read.table("traits.par.nfo",as.is=T,head=T)
m = match( rownames(df.traits) , traits.nfo$ID )
traits.nfo = traits.nfo[m,]
df.traits$num.loci = traits.nfo$NUM.LOCI
df.traits$num.joint.genes = traits.nfo$NUM.JOINT.GENES
df.traits$num.total.genes = traits.nfo$NUM.GENES

fout = "traits.md"
cat( "---","title: Traits","permalink: traits/","layout: traits","---\n",sep='\n',file=fout)
cat( "# *",nrow(df.traits),"* traits &middot; *",formatC(sum(df.traits$num.loci), format = "f", big.mark = ",", drop0trailing = TRUE),"* associated loci &middot; *", formatC(sum(df.traits$num.total.genes), format = "f", big.mark = ",", drop0trailing = TRUE),"*  gene/trait associations\n\n",sep='',file=fout,append=T)
cat( "| Type | Trait | N | # loci | # indep genes | # total genes | Ref. | Year | data | ","| --- |",sep='\n',file=fout,append=T)
write.table(df.traits[,c("type","link","n","num.loci","num.joint.genes","num.total.genes","ref","year","data")],quote=F,row.names=F,col.names=F,sep=' | ',file=fout,append=T)

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

genes.nfo = read.table("genes.nfo",as.is=T)
df.genes$n.assoc = genes.nfo[ match( df.genes$gene , genes.nfo[,1] ) , 2 ]
genes.nfo = read.table("genes.models.nfo",as.is=T)
df.genes$n.models = genes.nfo[ match( df.genes$gene , genes.nfo[,1] ) , 2 ]
df.genes$n.assoc[ is.na(df.genes$n.assoc) ] = 0
df.genes$n.models[ is.na(df.genes$n.models) ] = 0

df.json = df.genes[,c("gene","n.assoc","n.models")]
df.json$gene = paste( "<em><a href=\\\"./",df.json$gene,"\\\">",df.genes$gene,"</a></em>",sep='' )
cat( "{\n\"data\":[\n" , paste( "[\"" , df.json$gene , "\"," , df.json$n.assoc , "," , df.json$n.models , "]" , sep='' , collapse=",\n" ) , "]\n}" , sep='' , file= "genes.json" )

# ---- PRINT GENE INDEX
fout = "genes.md"
cat( "---","title: Genes","permalink: genes/","layout: genes","---\n",sep='\n',file=fout)
cat( "# *",formatC(nrow(df.genes), format = "f", big.mark = ",", drop0trailing = TRUE),"* genes &middot; *",formatC(sum(df.genes$n.models), format = "f", big.mark = ",", drop0trailing = TRUE),"* models\n\n",sep='',file=fout,append=T)
cat( "| Gene | # associations | # models |\n","| --- |\n| |\n",sep='',file=fout,append=T)
#write.table(df.genes[,c("link","n.assoc","n.models")],quote=F,row.names=F,col.names=F,sep=' | ',file=fout,append=T)
cat( '{: #genes}\n' ,file=fout,append=T)
# ----
