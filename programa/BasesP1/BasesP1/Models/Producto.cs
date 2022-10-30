using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    public class Producto
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

        [Display(Name = "Precio Estandar")]
        public float? PrecioEstandar { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "Codigo de Familia Producto")]
        public string? Codigo_Familia { get; set; }

    }
}
