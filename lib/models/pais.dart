class Pais {

  String nome;
  String imagemUrl;
  String capital;
  String regiao;
  int populacao;

  Pais(this.nome, this.imagemUrl, this.capital, this.regiao, this.populacao);
  
  static Pais fromJson(json) {
    String cap = "";
    if(json["capital"] != null && json["capital"] is List && json["capital"].isNotEmpty) {
      cap = json["capital"][0];
    }
    Pais p = Pais(json["name"]["common"], json["flags"]["png"], cap, json["region"] ?? "", json["population"] ?? 0);
    return p;
  }

}