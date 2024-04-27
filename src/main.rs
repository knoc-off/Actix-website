use actix_web::{web, App, HttpServer};
use actix_files::Files;

async fn index() -> actix_web::Result<actix_files::NamedFile> {
    Ok(actix_files::NamedFile::open("static/index.html")?)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(web::resource("/").to(index))
            .service(Files::new("/static", "./static").show_files_listing())
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}

