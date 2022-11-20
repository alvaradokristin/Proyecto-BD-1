using System.ComponentModel.DataAnnotations;
using System.Runtime.CompilerServices;

namespace BasesP1.Models
{
    public class Quotation
    {
        [Key]
        [Required]
        public Int16? numeroCotizacion { get; set; }

        [Required]
        [StringLength(12)]
        public string? nombreOportunidad { get; set; }

        [Required]
        public string? fecha { get; set; }

        [Required]
        [StringLength(7)]
        public string? mesAnnoCierre { get; set; }

        [Required]
        [StringLength(7)]
        public string? fechaCierre { get; set; }

        [Required]
        public Decimal? probabilidad { get; set; }

        [Required]
        [StringLength(30)]
        public string? descripcion { get; set; }

        [Required]
        [StringLength(15)]
        public string? seNego { get; set; }

        [Required]
        [StringLength(15)]
        public string? nombre_competencia { get; set; }

        [Required]
        public Int16? ordenCompra { get; set; }

        [Required]
        public Int16? numero_factura { get; set; }

        [Required]
        [StringLength(12)]
        public string? nombre_etapa { get; set; }

        [Required]
        [StringLength(10)]
        public string? categoria_tipo { get; set; }

        [Required]
        [StringLength(12)]
        public string? nombre_tipo { get; set; }

        [Required]
        [StringLength(10)]
        public string? codigo_ejecucion { get; set; }

        [Required]
        [StringLength(12)]
        public string? zona { get; set; }

        [Required]
        [StringLength(12)]
        public string? sector { get; set; }

        [Required]
        [StringLength(4)]
        public string? anno_inflacion { get; set; }

        [Required]
        [StringLength(10)]
        public string? codigo_caso { get; set; }

        [Required]
        [StringLength(10)]
        public string? login_usuario { get; set; }
        public int? cantidad { get; set; }
        public double? monto { get; set; }
        public string? codigoCleinte { get; set; }
        public string? nombreCuenta { get; set; }
    }
}