using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    public class Task
    {
        [Key]
        [Required]
        [StringLength(10)]
        public string? Codigo { get; set; }

        [Required]
        [StringLength(12)]
        public string? Nombre { get; set; }

        [Required]
        [StringLength(30)]
        public string? Descripcion { get; set; }

        [Required]
        [Display(Name = "Fecha de Inicio")]
        public DateTime? FechaInicio { get; set; }

        [Required]
        [Display(Name = "Fecha de Finalizacion")]
        public DateTime? FechaFinalizacion { get; set; }

        [Required]
        [StringLength(12)]
        public string? Estado { get; set; }

        [Required]
        [StringLength(10)]
        public string? Asesor { get; set; }
    }
}
