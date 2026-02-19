<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // create a default admin user for the Aimeos dashboard
        // the artisan command will take care of both the Laravel user record
        // and the corresponding Aimeos customer with the "admin" group
        $email = env('AIMEOS_ADMIN_EMAIL', 'admin@example.com');
        $password = env('AIMEOS_ADMIN_PASSWORD', 'secret');

        // avoid recreating the same account every time
        if( ! \App\Models\User::where('email', $email)->exists() ) {
            \Artisan::call('aimeos:account', [
                'email' => $email,
                '--password' => $password,
                '--admin' => true,
            ]);
        }

        // you can add additional seeders here or call
        // $this->call(OtherSeeder::class);
    }
}
