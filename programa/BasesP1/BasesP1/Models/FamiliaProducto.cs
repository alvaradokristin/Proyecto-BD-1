using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    public class FamiliaProducto
    {
        [Key]
        [Required]
        [StringLength(10)]
        public string? Codigo { get; set; }

        [Required]
        [StringLength(12)]
        public string? Nombre { get; set; }

        [Required]
        [StringLength(1)]
        public string? Activo { get; set; }

        [Required]
        [StringLength(30)]
        public string? Descripcion { get; set; }
    }
}
