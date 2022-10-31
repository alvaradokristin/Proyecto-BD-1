using BasesP1.Models;
using Microsoft.EntityFrameworkCore;

namespace BasesP1.Data
{
    public class SistemaCRMContext : DbContext
    {
        public SistemaCRMContext(DbContextOptions<SistemaCRMContext> options) : base(options)
        {
        }

        public DbSet<Producto>? Producto { set; get; }
        public DbSet<FamiliaProducto>? FamiliaProducto { set; get; }
        public DbSet<Client>? Client { set; get; }
    }
}
