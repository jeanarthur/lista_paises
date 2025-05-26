class Pais {

  String nome;
  String imagemUrl;

  Pais(this.nome, this.imagemUrl);
  
  static Pais fromJson(json) {
    Pais p = Pais(json["name"]["common"], json["flags"]["png"]);
    return p;
  }

}