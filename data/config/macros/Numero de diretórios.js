// Lista todos os arquivos no diret�rio do Notes
var searchresult= os.fileSearch(notes.getNotesDir() , '*', true);

// coloca o resultado em um array
arraydecaminhos= searchresult.split('\n');

// conta o n�mero de diret�rios
dircount = 0;

for (var i in arraydecaminhos){
    caminho = new String(arraydecaminhos[i]);
    if (caminho[caminho.length-1] == '\\'){
      dircount = dircount + 1;
    }
}

alert('O diret�rio do Notes (' + notes.getNotesDir() + ') tem ' + dircount + ' subdiret�rios!');


