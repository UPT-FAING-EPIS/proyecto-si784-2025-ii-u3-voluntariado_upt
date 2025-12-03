/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entidad;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/**
 *
 * @author Mi Equipo
 */
public class estudianteentidad {
    
    // Atributos para estadísticas del estudiante
    private int idEstudiante;
    private int horasAcumuladas;
    private int campanasInscritas;
    private int certificadosObtenidos;
    private int ranking;
    
    // Constructor vacío
    public estudianteentidad() {
    }
    
    // Constructor con parámetros
    public estudianteentidad(int idEstudiante, int horasAcumuladas, int campanasInscritas, 
                           int certificadosObtenidos, int ranking) {
        this.idEstudiante = idEstudiante;
        this.horasAcumuladas = horasAcumuladas;
        this.campanasInscritas = campanasInscritas;
        this.certificadosObtenidos = certificadosObtenidos;
        this.ranking = ranking;
    }
    
    // Getters y Setters
    public int getIdEstudiante() {
        return idEstudiante;
    }
    
    public void setIdEstudiante(int idEstudiante) {
        this.idEstudiante = idEstudiante;
    }
    
    public int getHorasAcumuladas() {
        return horasAcumuladas;
    }
    
    public void setHorasAcumuladas(int horasAcumuladas) {
        this.horasAcumuladas = horasAcumuladas;
    }
    
    public int getCampanasInscritas() {
        return campanasInscritas;
    }
    
    public void setCampanasInscritas(int campanasInscritas) {
        this.campanasInscritas = campanasInscritas;
    }
    
    public int getCertificadosObtenidos() {
        return certificadosObtenidos;
    }
    
    public void setCertificadosObtenidos(int certificadosObtenidos) {
        this.certificadosObtenidos = certificadosObtenidos;
    }
    
    public int getRanking() {
        return ranking;
    }
    
    public void setRanking(int ranking) {
        this.ranking = ranking;
    }
    
    @Override
    public String toString() {
        return "EstudianteEntidad{" +
                "idEstudiante=" + idEstudiante +
                ", horasAcumuladas=" + horasAcumuladas +
                ", campanasInscritas=" + campanasInscritas +
                ", certificadosObtenidos=" + certificadosObtenidos +
                ", ranking=" + ranking +
                '}';
    }
}