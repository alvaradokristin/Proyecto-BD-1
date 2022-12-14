using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    public class Activity
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
        [StringLength(12)]
        public string? Estado { get; set; }

        [Required]
        [StringLength(12)]
        public string? Tipo { get; set; }

        [Required]
        [StringLength(10)]
        public string? Asesor { get; set; }

        public string? TipoQuery { get; set; }
        public string? FKCont { get; set; }
        public string? FKMot { get; set; }
    }
}
