// Converte URLs para links
// TODO selecionar o URL automagicamente se o usu�rio n�o o tiver feito
if (editor.getSelLength() > 0){
  editor.insert( '<a href="' + editor.getSelText() + '">' + editor.getSelText()  + '</a>');
} else {
  alert('Por favor, selecione o URL!');
}


