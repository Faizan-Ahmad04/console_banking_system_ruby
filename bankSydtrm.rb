require 'win32console'

class Bank
    @@all_accounts = []
    @@logged_in_user = nil

    def self.validate_account_number_age(num)
        num.match?(/^\d+$/)
    end

    def self.validate_balance(balance)
        balance.match?(/^\d+(\.\d+)?$/)
    end

    def self.validate_name(name)
        !name.strip.empty? && name.match?(/^[a-zA-Z\s]+$/)
    end


    def self.dummy_account
        account = { full_name: "dummy user", age: 22, balance: 1001.99, account_number: 9071149915063315 }
        @@all_accounts << account
    end
    self.dummy_account

    def self.create_account
        
        system 'cls'
        puts 'Create an account'

        print "Enter your full name: "
        full_name = gets.chomp
        valid_name = self.validate_name(full_name)

        if valid_name
            print "Enter your age: "
            age = gets.chomp
            is_age = self.validate_account_number_age(age)
            
            if  is_age && age.to_i.positive? 
                print "Enter your initial balance: "
                balance = gets.chomp
                initial_valance_f = balance.to_f
                valid_balance = self.validate_balance(balance)

                if valid_balance && initial_valance_f.positive?
                
                    account_number = generate_account_number.to_s
                    valid_number = self.validate_account_number_age(account_number)

                    if valid_number
                        account = { full_name: full_name, age: age, balance: initial_valance_f, account_number: account_number.to_i }
                        @@all_accounts << account
                        puts "Account created successfully"
                        puts "Full Name: #{full_name}"
                        puts "Account number: #{account_number}"
                        puts "Balance: #{balance}"
                    else
                        puts "Invalid account number"
                    end
                else
                    puts "Invalid initial valance. please enter a valid amount. "
                    gets
                    self.create_account
                end
            else
                puts "Invalid age. Please enter a valid age."
                puts "Press enter to continue"
                gets
                self.create_account
            end
        else
            puts "Invalid name. Please enter a valid name without special characters."
            puts "Press enter to continue"
            gets
            self.create_account
        end

        puts "Press enter to continue"
        gets
    end

    def self.login_account
        system "cls"
        puts "Login your account"

        print "Enter your account number: "
        account_number = gets.chomp

        if self.validate_account_number_age(account_number)
            account = @@all_accounts.find { |acc| acc[:account_number] == account_number.to_i }

            if account
                @@logged_in_user = account
                puts "Login successfully"
                puts "Welcome #{@@logged_in_user[:full_name]}"

                loop do
                    self.display_login_console_menu
                    print "Enter your choice: "
                    choice = gets.chomp.to_i

                    case choice
                    when 1
                        puts "Your Balance is: #{@@logged_in_user[:balance]}"
                    when 2
                        puts "Enter Amount to withdraw"
                        withdraw_amount = gets.chomp
                        widthdraw = self.validate_balance(withdraw_amount)           
                        if widthdraw && withdraw_amount.to_f.positive? && withdraw_amount.to_f<=@@logged_in_user[:balance]
                            @@logged_in_user[:balance] -= withdraw_amount.to_f
                            puts "Successfully withdraw #{withdraw_amount}"
                            puts "Your current Balance is: #{@@logged_in_user[:balance]}"
                        else
                            puts "Invalid amount"
                        end
                    when 3
                        puts "Enter Amount to deposit"
                        deposit_amount = gets.chomp
                        deposit = self.validate_balance(deposit_amount)
                        if deposit  && deposit_amount.to_f.positive?
                            @@logged_in_user[:balance] += deposit_amount.to_f
                            puts "Successfully deposit #{deposit_amount}"
                            puts "Your current Balance is: #{@@logged_in_user[:balance]}"
                        else
                            puts "Invalid amount"
                        end
                    when 4
                        puts "Enter receiver account number. "
                        receiver_account_number = gets.chomp
                        valid_receiver_account_number = self.validate_account_number_age(receiver_account_number)
                        
                        if valid_receiver_account_number && receiver_account_number.to_i.positive?
                            account = @@all_accounts.find { |acc| acc[:account_number] == receiver_account_number.to_i }
                            
                            if account 
                                if (receiver_account_number.to_i != account[:account_number])
                                    puts "Enter amount. " 
                                    amount = gets.chomp
                                    valid_amount = self.validate_balance(amount)
                                    if valid_amount && amount.to_f.positive?
                                        @@logged_in_user[:balance] -= amount.to_f
                                        account[:balance] += amount.to_f
                                        puts "Sucessfully transfer #{amount} to #{account[:full_name]}'s account"
                                    else
                                        puts "Invalid amount or account number"
                                    end
                                else
                                    puts "Can't transfer in same account."
                                end
                            else
                                puts "Enter valid account number"
                                
                            end
                        else 
                            puts "Enter valid account number"
                        end  
                    when 5
                        puts "Thank you for using console Banking. "
                        break
                    else
                        puts "Invalid choice. Please try again."
                    end
                    puts "Press enter to continue"
                    gets
                end
            else
                puts "Invalid account number. Please try again"
                puts "Press enter to continue"
                gets
                self.login_account
            end
        else
            puts "Invalid account number. Please enter a valid account number without special characters."
            self.login_account
        end
        puts "Press enter to continue"
        gets
    end

    def self.logout_account
        system "cls"    
        puts "Logging out"

        @@logged_in_user = nil

        puts "Logout successfully"
        puts "Press enter to continue"
        gets
    end

    def self.generate_account_number
        return rand(14**14)
    end

    def self.display_login_console_menu
        system "cls"
        puts "1. Check Balance"
        puts "2. Withdraw"
        puts "3. Deposit"
        puts "4. Transfer"
        puts "5. Exit"
    end
end

def display_console_menu
    system "cls"
    puts "Welcome to console banking"
    puts "1. Create an account"
    puts "2. Login"
    puts "3. Logout"
    puts "4. Exit"
end

loop do
    display_console_menu
    print "Enter your choice: "
    choice = gets.chomp.to_i

    case choice
    when 1
        Bank.create_account
    when 2
        Bank.login_account
    when 3
        Bank.logout_account
    when 4
        puts "Thank you for using console Banking. "
        break
    else
        puts "Invalid choice. Please try again."
        puts "Press enter to continue"
        gets
    end
end

 
