package entidad;

import java.sql.Timestamp;

public class Asistencia {
    
    private int idAsistencia;
    private int idInscripcion;
    private int idCampana;
    private int idEstudiante;
    private Timestamp fechaRegistro;
    private String tipoRegistro;
    private boolean presente;
    private String observaciones;
    
    // Constructor vacío
    public Asistencia() {
    }
    
    // Constructor con parámetros principales
    public Asistencia(int idInscripcion, int idCampana, int idEstudiante, boolean presente) {
        this.idInscripcion = idInscripcion;
        this.idCampana = idCampana;
        this.idEstudiante = idEstudiante;
        this.presente = presente;
        this.fechaRegistro = new Timestamp(System.currentTimeMillis());
        this.tipoRegistro = "MANUAL";
    }
    
    // Getters y Setters
    public int getIdAsistencia() {
        return idAsistencia;
    }
    
    public void setIdAsistencia(int idAsistencia) {
        this.idAsistencia = idAsistencia;
    }
    
    public int getIdInscripcion() {
        return idInscripcion;
    }
    
    public void setIdInscripcion(int idInscripcion) {
        this.idInscripcion = idInscripcion;
    }
    
    public int getIdCampana() {
        return idCampana;
    }
    
    public void setIdCampana(int idCampana) {
        this.idCampana = idCampana;
    }
    
    public int getIdEstudiante() {
        return idEstudiante;
    }
    
    public void setIdEstudiante(int idEstudiante) {
        this.idEstudiante = idEstudiante;
    }
    
    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }
    
    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
    
    public String getTipoRegistro() {
        return tipoRegistro;
    }
    
    public void setTipoRegistro(String tipoRegistro) {
        this.tipoRegistro = tipoRegistro;
    }
    
    public boolean isPresente() {
        return presente;
    }
    
    public void setPresente(boolean presente) {
        this.presente = presente;
    }
    
    public String getObservaciones() {
        return observaciones;
    }
    
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
    
    @Override
    public String toString() {
        return "Asistencia{" +
                "idAsistencia=" + idAsistencia +
                ", idInscripcion=" + idInscripcion +
                ", idCampana=" + idCampana +
                ", idEstudiante=" + idEstudiante +
                ", fechaRegistro=" + fechaRegistro +
                ", tipoRegistro='" + tipoRegistro + '\'' +
                ", presente=" + presente +
                ", observaciones='" + observaciones + '\'' +
                '}';
    }
}