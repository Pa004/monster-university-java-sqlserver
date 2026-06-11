package ec.edu.monster.modelo;

public class Perfil {

    private String codigo;        // XEPER_CODIGO
    private String descripcion;   // XEPER_DESCRIP
    private String observacion;   // XEPER_OBS

    public Perfil() {
    }

    public Perfil(String codigo, String descripcion, String observacion) {
        this.codigo = codigo;
        this.descripcion = descripcion;
        this.observacion = observacion;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }
}
