package ec.edu.monster.controlador;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "srvMedia", urlPatterns = {"/media"})
public class srvMedia extends HttpServlet {

    private static final String UPLOAD_DIR = System.getProperty("user.home") + File.separator + "monsteru" + File.separator + "uploads" + File.separator + "fotos";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String p = request.getParameter("p");
        if (p == null || p.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Solo permitir servir archivos bajo uploads/fotos por seguridad
        String filename = Paths.get(p).getFileName().toString();
        Path filePath = Paths.get(UPLOAD_DIR).resolve(filename);

        if (!Files.exists(filePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mime = Files.probeContentType(filePath);
        if (mime == null) mime = "image/jpeg";
        response.setContentType(mime);
        response.setHeader("Cache-Control", "public, max-age=86400");

        try (FileInputStream fis = new FileInputStream(filePath.toFile()); OutputStream os = response.getOutputStream()) {
            fis.transferTo(os);
        }
    }
}
