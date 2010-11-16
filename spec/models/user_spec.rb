require 'spec_helper'

describe User do

   before(:each)    do
     @attr = {:name => "Example User",
	      :email => "user@eample.com",
              :password => "foobar",
              :password_confirmation => "foobar"
             }
   end

   #Testing for user's name and email presence

   it "should create a new instance given valid attributes" do
     User.create!(@attr)
   end

   it "should require a name" do
      no_name_user=User.new(@attr.merge(:name=>""))
      no_name_user.should_not be_valid
   end

   #pending "add some examples to (or delete) #{__FILE__}"

   #Testing   length of user's email and name

   it "should require an email address" do
      no_email_user=User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
   end


   it "should reject names that are too long" do
       long_name ="a"*51
       long_name_user=User.new(@attr.merge(:name => long_name))
       long_name_user.should_not be_valid
   end


   #Testing of user's email format

   it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  # Testing of reject duplicate email address when click submit button more than one time
  it "should reject duplicate email address " do
     User.create!(@attr)
     user_with_duplicate_email = User.new(@attr)
     user_with_duplicate_email.should_not be_valid
  end

  #Testing  of email address identical Upcase
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  #Testing for  passswoed validations  , added at 11/14/2010

  describe "password validations " do
     #(1)  Testing  of presence of password and comfirmtion
    it "should require a password " do
       User.new(@attr.merge(:password => "",:password_confirmation =>"" ))
       should_not be_valid
     end

     #(2)  Testing  of password and password_comfirmtion  matching
     it "should require a matching password confirmation" do
 	User.new(@attr.merge(:password_confirmation => "invalid"))
	   should_not be_valid
    end
     #(3)  Testing of password and password_comfirmation length
    it "should reject short passwords " do
	short = "a"*5
	hash =@attr.merge(:password => short, :password_confirmation => short)
	User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
	long= "a"*41
	long=@attr.merge(:passowrd => long ,:password_confirmation => long)
	User.new(hash).should_not be_valid
    end
  end

  #Testing fot existence of encrypted_password  11/14/2010
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
  end

  describe "authenticate method" do
     it "should return nil om email/password mismatch" do
       wrong_password_user = User.authenticate(@attr[:email],"wrongpass")
       wrong_password_user.should be_nil
     end

     it "should renturn nil for an email address with no user" do
       nonexistent_user=User.authenticate("bar@foo.com",@attr[:password])
       nonexistent_user.should be_nil

     end

     it "should return the user on email/password match" do
       matching_user=User.authenticate(@attr[:email],@attr[:password])
       matching_user.should == @user
     end
  end


end

